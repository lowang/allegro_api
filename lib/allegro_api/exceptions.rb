module AllegroApi
  class ApiError < StandardError
  end

  class UnknownField < StandardError
    def initialize(fid)
      @fid = fid.to_i
      super "Unknown field (fid = %d)" % @fid
    end
  end
end