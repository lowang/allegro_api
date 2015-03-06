module AllegroApi
  class Item
    attr_accessor :id
    attr_accessor :title
    attr_accessor :thumbnail_url
    attr_accessor :price
    attr_accessor :start_quantity
    attr_accessor :sold_quantity
    attr_accessor :starts_at
    attr_accessor :ends_at
    attr_accessor :bidders_count
    attr_accessor :category_id
    attr_accessor :watchers_count
    attr_accessor :views_count

    attr_accessor :deals, :amount


    def self.from_api(data)
      item = new
      item.id = data[:item_id].to_i
      item.title = data[:item_title]
      item.thumbnail_url = data[:item_thumbnail_url]
      buy_now = data[:item_price][:item]
      if buy_now.is_a? Array
        price_item = buy_now.select {|e| e.price_type.to_i == 1}
      else
        price_item = buy_now
      end
      price = price_item[:price_value].to_f
      item.price = buy_now[:price_value].to_f
      item.start_quantity = data[:item_start_quantity].to_i
      item.sold_quantity = data[:item_sold_quantity].to_i
      item.starts_at = Time.at data[:item_start_time].to_i
      item.ends_at = Time.at data[:item_end_time].to_i
      item.bidders_count = data[:item_bidders_counter].to_i
      item.watchers_count = data[:item_watchers_counter].to_i
      item.views_count = data[:item_views_counter].to_i
      item.category_id = data[:item_category_id].to_i
      item
    end
  end
end
