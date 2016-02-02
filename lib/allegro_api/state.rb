module AllegroApi
  class State
    include ActiveModel::Model
    attr_accessor :id
    attr_accessor :name

    STATES = [['dolnośląskie', 1], ['kujawsko-pomorskie', 2], ['lubelskie', 3], ['lubuskie', 4], ['łódzkie', 5], ['małopolskie', 6],
              ['mazowieckie', 7], ['opolskie', 8], ['podkarpackie', 9], ['podlaskie', 10], ['pomorskie', 11], ['śląskie', 12], ['świętokrzyskie', 13],
              ['warmińsko-mazurskie', 14], ['wielkopolskie', 15], ['zachodniopomorskie', 16]]
    ID_TO_STATE_MAP = Hash[*STATES.flatten.reverse]
    STATE_TO_ID_MAP = Hash[*STATES.flatten]

    def self.find_by_id(state_id)
      ID_TO_STATE_MAP[state_id] && new(id: state_id, name: ID_TO_STATE_MAP[state_id])
    end
    def self.find_by_name(state_name)
      return unless state_name.present?
      state_name = state_name.downcase
      STATE_TO_ID_MAP[state_name] && new(id: STATE_TO_ID_MAP[state_name], name: state_name)
    end
  end
end
