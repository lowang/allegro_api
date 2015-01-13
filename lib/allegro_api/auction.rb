module AllegroApi
  class Auction
    attr_reader :fields

    def initialize
      @fields = Hash.new
    end


    def self.from_api(data)
      auction = new
      data.each do |field_data|
        fid = field_data[:fid].to_i
        auction.fields[fid] = Field.find(fid).value_from_api(field_data)
      end
      auction
    end


    def to_api
      api_data = []
      fields.each_pair do |fid, value|
        api_data << field_api_value(fid, value)
      end
      api_data
    end

    private

    def field_api_value(fid, value)
      api_data = { fid: fid,
        fvalue_string: "",
        fvalue_int: 0,
        fvalue_float: 0,
        fvalue_image: '',
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {fvalue_range_int_min: 0,
          fvalue_range_int_max: 0},
        fvalue_range_float: {fvalue_range_float_min: 0,
          fvalue_range_float_max: 0},
        fvalue_range_date: {fvalue_range_date_min: '',
        fvalue_range_date_max: ''} }

        case value
        when Integer then api_data[:fvalue_int] = value
        when Float then api_data[:fvalue_float] = value
        when String then api_data[:fvalue_string] = value
        when Date then api_data[:fvalue_date] = value.strftime '%d-%m-%Y'
        when Time then api_data[:fvalue_datetime] = value.to_i
        when Range
          case value.min
          when Integer
            api_data[:fvalue_range_int][:fvalue_range_int_min] = value.min
            api_data[:fvalue_range_int][:fvalue_range_int_max] = value.max
          when Float
            api_data[:fvalue_range_float][:fvalue_range_float_min] = value.min
            api_data[:fvalue_range_float][:fvalue_range_float_max] = value.max
          when Date
            api_data[:fvalue_range_date][:fvalue_range_date_min] = value.min.strftime '%d-%m-%Y'
            api_data[:fvalue_range_date][:fvalue_range_date_max] = value.max.strftime '%d-%m-%Y'
          end
        end
        api_data
    end
  end
end