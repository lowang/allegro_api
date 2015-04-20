module AllegroApi
  class Auction
    attr_accessor :id

    attr_reader :fields
    attr_reader :photos

    def initialize
      @fields = Hash.new
      @photos = Array.new
    end


    def self.from_api(data)
      auction = new
      data.each do |field_data|
        fid = field_data[:fid].to_i
        if AllegroApi::Fid::PHOTO_FIELDS.include? fid
          auction.photos << Field.find(fid).value_from_api(field_data)
        else
          auction.fields[fid] = Field.find(fid).value_from_api(field_data)
        end
      end
      auction
    end

    def self.field_accessor(name, field_id)
      self.class_eval %Q{
        def #{name}=(value)
          self.fields[#{field_id}] = value
        end

        def #{name}
          self.fields[#{field_id}]
        end
      }
    end

    def to_api
      api_data = []
      fields.each_pair do |fid, value|
        api_data << field_api_value(fid, value)
      end
      photo_idx = 0
      AllegroApi::Fid::PHOTO_FIELDS.each do |fid|
        break unless photos[photo_idx]
        api_data << field_api_value(fid, photos[photo_idx])
        photo_idx += 1
      end
      api_data
    end

    field_accessor :name, AllegroApi::Fid::NAME
    field_accessor :category_id, AllegroApi::Fid::CATEGORY
    field_accessor :duration, AllegroApi::Fid::DURATION
    field_accessor :quantity, AllegroApi::Fid::QUANTITY
    field_accessor :quantity_type, AllegroApi::Fid::QUANTITY_TYPE
    field_accessor :promo_options, AllegroApi::Fid::PROMO_OPTIONS
    field_accessor :bank_account, AllegroApi::Fid::BANK_ACCOUNT_1
    field_accessor :price, AllegroApi::Fid::BUY_NOW_PRICE
    field_accessor :country, AllegroApi::Fid::COUNTRY
    field_accessor :city, AllegroApi::Fid::CITY
    field_accessor :info, AllegroApi::Fid::INFO
    field_accessor :zipcode, AllegroApi::Fid::ZIPCODE
    field_accessor :province, AllegroApi::Fid::PROVINCE

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
          when Float, BigDecimal then api_data[:fvalue_float] = value
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
          when Image then api_data[:fvalue_image] = value.to_api
        end
        api_data
    end
  end
end
