require 'spec_helper'
require_relative '../test_cache'

describe AllegroApi::Repository::Account do

  let(:session_id) { 1234 }
  let(:user_id) { 5 }
  let(:client) { AllegroApi::Client.new }
  let(:session) { AllegroApi::Session.new(client, session_id, user_id) }
  let(:accounts_repository) { session.accounts }

  describe "#current" do
    let(:parsed_api_response) { Psych.load_file(File.join(AllegroApi.root, 'spec/fixtures/do_get_my_data_company.yml')) }
    subject { accounts_repository.current }
    before do
      expect(client).to receive(:call).with(:do_get_my_data, any_args).and_return(do_get_my_data_response: parsed_api_response)
    end
    it { is_expected.to be_a(AllegroApi::Account) }
    it { is_expected.to have_attributes(id: 6879039, login: 'ELECTROpl',
      rating:0, first_name:"Zenon", last_name:"Nowak", maiden_name:"XXXNONAMEXXX", country_id:1, state_id:11,
      post_code:"77-400", city:"Złotów", address:"Za Dworcem 1 d", email:"zenon.nowak@electro.pl", phone:"22 122 32 00",
      phone2: nil, is_super_seller: false, is_junior: false, has_shop: false, is_company: true, is_allegro_standard: false)
    }
    describe "company" do
      subject { accounts_repository.current.company }
      it { is_expected.to be_a(AllegroApi::Company) }
      it { is_expected.to have_attributes(name: "TERG S.A.", type:"spółka akcyjna", nip:"7671004218", regon:"570217011",
        krs:"427063", activity_sort:nil, worker_first_name:nil, worker_last_name:nil) }
    end
    context "plain user" do
      let(:parsed_api_response) { Psych.load_file(File.join(AllegroApi.root, 'spec/fixtures/do_get_my_data_plain_user.yml')) }
      it { is_expected.to be_a(AllegroApi::Account) }
    end
  end
end
