module AllegroApi
  class Country
    include ActiveModel::Model
    attr_accessor :id
    attr_accessor :name
    attr_accessor :iso
    attr_accessor :iso3

    COUNTRIES = { 1 => { iso: "PL", iso3: "POL", name: "Polska" }, 56 => { iso: "CZ", iso3: "CZE", name: "Czechy"},
      93 => { iso: "HU", iso3: "HUN", name: "Węgry" }, 168 => { iso: "RU", iso3: "RUS", name: "Rosja" },
      209 => { iso: "UA", iso3: "UKR", name: "Ukraina" }}

    def self.find_by_id(country_id)
      new({id: country_id}.merge(COUNTRIES[country_id]))
    end
  end
end
