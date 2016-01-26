require_relative '../spec_helper'

describe AllegroApi::Session do
  let(:session_id) { 1234 }
  let(:user_id) { 5 }
  let(:wsdl_url) { 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl' }

  let(:client) { AllegroApi::Client.new wsdl: wsdl_url }
  let(:session) { AllegroApi::Session.new(client, session_id, user_id) }

  it 'provides session id' do
    expect(session.id).to eq session_id
  end

  it 'provides user id' do
    expect(session.user_id).to eq user_id
  end

end
