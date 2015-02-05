module AllegroApi
  class Auction
    attr_accessor :id

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

    def name=(value)
      self.fields[AllegroApi::Fid::NAME] = value
    end

    def name
      self.fields[AllegroApi::Fid::NAME]
    end

    def category_id=(value)
      self.fields[AllegroApi::Fid::CATEGORY] = value
    end

    def category_id
      self.fields[AllegroApi::Fid::CATEGORY]
    end

    def duration=(value)
      self.fields[AllegroApi::Fid::DURATION] = value
    end

    def duration
      self.fields[AllegroApi::Fid::DURATION]
    end


    def quantity=(value)
      self.fields[AllegroApi::Fid::QUANTITY] = value
    end

    def quantity
      self.fields[AllegroApi::Fid::QUANTITY]
    end

    def price=(value)
      self.fields[AllegroApi::Fid::BUY_NOW_PRICE] = value
    end

    def price
      self.fields[AllegroApi::Fid::BUY_NOW_PRICE]
    end

    def country=(value)
      self.fields[AllegroApi::Fid::COUNTRY] = value
    end

    def country
      self.fields[AllegroApi::Fid::COUNTRY]
    end

    def city=(value)
      self.fields[AllegroApi::Fid::CITY] = value
    end

    def city
      self.fields[AllegroApi::Fid::CITY]
    end

    def info=(value)
      self.fields[AllegroApi::Fid::INFO] = value
    end

    def info
      self.fields[AllegroApi::Fid::INFO]
    end

    def zipcode=(value)
      self.fields[AllegroApi::Fid::ZIPCODE] = value
    end

    def zipcode
      self.fields[AllegroApi::Fid::ZIPCODE]
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
          when Image then api_data[:fvalue_image] = value.to_api
        end
        api_data
    end
  end
end