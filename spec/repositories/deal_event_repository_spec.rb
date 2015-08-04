require 'spec_helper'

describe AllegroApi::Repository::DealEvent do

  let(:session_id) { 1234 }
  let(:user_id) { 5 }
  let(:wsdl_url) { 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl' }
  let(:client) { AllegroApi::Client.new wsdl: wsdl_url }
  let(:session) { AllegroApi::Session.new(client, session_id, user_id) }
  let(:deal_events_repository) { session.deal_events }

  describe '#each' do
    let(:deal_events) do
      7.times.map { |i| event = AllegroApi::DealEvent.new; event.id = i; event }
    end

    let(:in_block_code) { double }

    before do
      allow(deal_events_repository).to receive(:count_deal_events).and_return(deal_events.size)
      allow(deal_events_repository).to receive(:get_deal_events).and_return(deal_events[0..3], deal_events[4..6])
    end

    it 'performs code of the block for each page of events' do
      expect(in_block_code).to receive(:call).with(AllegroApi::DealEvent).exactly(7).times
      event_ids = []
      deal_events_repository.each {|event| event_ids  << event.id; in_block_code.call(event) }
      expect(event_ids).to eq([0,1,2,3,4,5,6])
      expect(deal_events_repository.size).to eq(7)
    end
  end

  describe '#count_deal_events' do
    context 'without specifying start point' do
      it 'invokes doGetSiteJournalInfo SOAP request' do
        expect(client).to receive(:call).with(:do_get_site_journal_deals_info, session_id: 1234).and_return(
          {do_get_site_journal_deals_info_response: {site_journal_deals_info: {deal_events_count: 0, deal_last_event_time: 0}}})
        deal_events_repository.size
      end
    end

    context 'with starting point' do
      it 'invokes doGetSiteJournalInfo SOAP request' do
        expect(client).to receive(:call).with(:do_get_site_journal_deals_info, session_id: 1234,
          journal_start: 4321).and_return(
            {do_get_site_journal_deals_info_response: {site_journal_deals_info: {deal_events_count: 0, deal_last_event_time: 0}}})
        deal_events_repository.from(4321).size
      end
    end

    context 'on success' do
      let(:events_count) { deal_events_repository.size }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_site_journal_deals_info_success'
      end

      it 'returns the number of events' do
        expect(events_count).to eq 5
      end
    end
  end

  describe '#get_deal_events' do
    subject { deal_events_repository.to_a }

    context 'without specifying start point' do
      it 'invokes doGetSiteJournalDeals SOAP request' do
        expect(deal_events_repository).to receive(:count_deal_events).and_return(1)
        expect(client).to receive(:call).with(:do_get_site_journal_deals, session_id: 1234).and_return(
          {do_get_site_journal_deals_response: {site_journal_deals: {item: [{deal_event_id:1}]}}})
        subject
      end
    end

    context 'with starting point' do
      it 'invokes doGetSiteJournalDeals SOAP request' do
        expect(deal_events_repository).to receive(:count_deal_events).and_return(1)
        expect(client).to receive(:call).with(:do_get_site_journal_deals, session_id: 1234,
          journal_start: 4321).and_return(
          {do_get_site_journal_deals_response: {site_journal_deals: {item: [deal_event_id:1]}}})
        deal_events_repository.from(4321).to_a
      end
    end

    context 'on success without events' do
      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_site_journal_deals_success'
      end
      it 'returns an array of deal events' do
        expect(deal_events_repository).to receive(:count_deal_events).and_return(1)
        expect(subject).to be_instance_of Array
        expect(subject.size).to eq 1
        expect(subject).to all(be_instance_of AllegroApi::DealEvent)
      end
    end


    context 'on success without events' do
      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_site_journal_deals_no_events'
      end
      it 'returns an array of journal events' do
        expect(deal_events_repository).to receive(:count_deal_events).and_return(0)
        expect(subject).to be_instance_of Array
        expect(subject.size).to eq 0
      end
    end
  end
end
