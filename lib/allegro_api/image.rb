require 'base64'

module AllegroApi
  class Image
    attr_accessor :data

    def initialize(params = {})
      @data = params[:data]
    end

    def to_api
      Base64.encode64(Base64.encode64(data))
    end

    def self.from_api(api_data)
      Image.new data: Base64.decode64(Base64.decode64(api_data))
    end
  end
end
