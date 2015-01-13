class TestCache
  def initialize
    @collections = Hash.new {|hash, key| hash[key] = {}}
  end


  def fetch(collection, key)
    @collections[collection][key]
  end

  def store(collection, key, value)
    @collections[collection][key] = value
  end
end