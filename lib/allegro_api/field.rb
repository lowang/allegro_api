require 'date'

module AllegroApi
  class Field
    FIELD_TYPES = {
      1 => :string,
      2 => :integer,
      3 => :float,
      4 => :combobox,
      5 => :radiobutton,
      6 => :checkbox,
      7 => :image, # (base64Binary)
      8 => :text, # (textarea)
      9 => :datetime, # (Unix time)
      13 => :date
    }

    VALUE_TYPES = {
      1 => :string,
      2 => :integer,
      3 => :float,
      7 => :image,   # (base64Binary),
      9 => :datetime, # (Unix time)
      13 => :date
    }

    attr_accessor :id
    attr_accessor :title
    attr_accessor :category_id
    attr_accessor :field_type
    attr_accessor :value_type
    attr_accessor :required
    attr_accessor :max_length
    attr_accessor :min_value
    attr_accessor :max_value
    attr_accessor :value_set #sell_form_opts_values => #sell_form_desc
    attr_accessor :options
    attr_accessor :default_value
    attr_accessor :unit
    attr_accessor :description

    def self.find(id)
      field = AllegroApi.cache.fetch(:fields, id)
      raise UnknownField.new(id) unless field
      field
    end

    def self.from_api(fdata)
      field = Field.new
      field.id = fdata[:sell_form_id].to_i
      field.title = fdata[:sell_form_title].to_s
      field.category_id = fdata[:sell_form_cat].to_i
      field.field_type = FIELD_TYPES[fdata[:sell_form_type].to_i]
      field.value_type = VALUE_TYPES[fdata[:sell_form_res_type].to_i]
      field.required = fdata[:sell_form_opt] == '1'
      field.max_length = fdata[:sell_form_length].to_i
      value = fdata[:sell_min_value].to_f
      field.min_value = value if value > 0
      value = fdata[:sell_max_value].to_f
      field.options = fdata[:sell_form_options].to_i
      field.max_value = value if value > 0
      option_descriptions = fdata[:sell_form_desc].to_s.split '|' if fdata[:sell_form_desc]
      option_values = fdata[:sell_form_opts_values].split('|').map(&:to_i) if fdata[:sell_form_opts_values]
      if option_descriptions && option_values
        field.value_set = Hash[option_values.zip option_descriptions]
      end
      field.default_value = fdata[:sell_form_def_value]
      field.unit = fdata[:sell_form_unit].to_s
      field.description = fdata[:sell_form_field_desc].to_s
      field
    end


    def initialize(params = {})
      @id = params[:id]
      @title = params[:title]
      @category_id = params[:category_id]
      @field_type = params[:field_type].to_sym if params[:field_type]
      @value_type = params[:value_type].to_sym if params[:value_type]
      @required = params[:required]
      @max_length = params[:max_length]
      @min_value = params[:min_value]
      @max_value = params[:max_value]
      @value_set = params[:value_set]
      @options = params[:options]
      @default_value = params[:default_value]
      @unit = params[:unit]
      @description = params[:description]
    end

    def range_field?
      @options == 8
    end

    def value_from_api(data)
      case value_type
      when :string then data[:fvalue_string]
      when :date
        if range_field?
          Date.strptime(data[:fvalue_range_date][:fvalue_range_date_min], '%d-%m-%Y')..Date.strptime(data[:fvalue_range_date][:fvalue_range_date_max], '%d-%m-%Y')
        else
          Date.strptime data[:fvalue_date], '%d-%m-%Y'
        end
      when :integer
        if range_field?
          data[:fvalue_range_int][:fvalue_range_int_min].to_i..data[:fvalue_range_int][:fvalue_range_int_max].to_i
        else
          data[:fvalue_int].to_i
        end
      when :float
        if range_field?
          data[:fvalue_range_float][:fvalue_range_float_min].to_f..data[:fvalue_range_float][:fvalue_range_float_max].to_f
        else
          data[:fvalue_float].to_f
        end
      when :datetime then Time.at(data[:fvalue_datetime].to_i)
      when :image then AllegroApi::Image.from_api(data[:fvalue_image])
      else
        raise "unknown value_type #{value_type}"
      end
    end
  end
end