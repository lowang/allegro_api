module AllegroApi
  class Category
    attr_accessor :id
    attr_accessor :name
    attr_accessor :parent_id
    attr_accessor :position

    def self.from_api(data)
      new id: data[:cat_id].to_i,
        name: data[:cat_name],
        parent_id: data[:cat_parent].to_i,
        position: data[:cat_position].to_i
    end


    def initialize(params = {})
      @id = params[:id]
      @name = params[:name]
      @parent_id = params[:parent_id]
      @position = params[:position]
    end
  end
end