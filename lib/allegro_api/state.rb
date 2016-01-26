module AllegroApi
  class State
    include ActiveModel::Model
    attr_accessor :id
    attr_accessor :name

    STATES = [['dolnośląskie', 1], ['kujawsko-pomorskie', 2], ['lubelskie', 3], ['lubuskie', 4], ['łódzkie', 5], ['małopolskie', 6],
              ['mazowieckie', 7], ['opolskie', 8], ['podkarpackie', 9], ['podlaskie', 10], ['pomorskie', 11], ['śląskie', 12], ['świętokrzyskie', 13],
              ['warmińsko-mazurskie', 14], ['wielkopolskie', 15], ['zachodniopomorskie', 16]]
    ID_TO_STATE_MAP = Hash[*STATES.flatten.reverse]

    def self.find_by_id(state_id)
      new(id: state_id, name: ID_TO_STATE_MAP[state_id])
    end
  end
end
