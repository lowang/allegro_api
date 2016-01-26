require_relative '../spec_helper'

describe AllegroApi::Country do
  let(:country_id) { self.class.metadata[:description].to_i }
  subject { AllegroApi::Country.find_by_id(country_id) }

  describe '1' do
    it { is_expected.to have_attributes(name: 'Polska', iso: 'PL', iso3: 'POL', id:1) }
  end
  describe '209' do
    it { is_expected.to have_attributes(name: 'Ukraina', iso: 'UA', iso3: 'UKR', id:209) }
  end
end
