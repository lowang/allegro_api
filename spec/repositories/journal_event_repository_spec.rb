require 'spec_helper'

describe AllegroApi::Repository::JournalEvent do
  let(:session_id) { 1234 }
  let(:user_id) { 5 }
  let(:wsdl_url) { 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl' }

  let(:client) { AllegroApi::Client.new wsdl: wsdl_url }
  let(:session) { AllegroApi::Session.new(client, session_id, user_id) }
  let(:journal_events_repository) { session.journal_events }

  describe '#each' do
    let(:in_block_code) { double }
    let(:journal_events) do
      8.times.map { |i| event = AllegroApi::JournalEvent.new; event.id = i; event }
    end

    before do
      allow(journal_events_repository).to receive(:count_site_journal_events).and_return(journal_events.size)
      allow(journal_events_repository).to receive(:get_site_journal_events).and_return(journal_events[0..3], journal_events[4..7])
    end

    it 'performs code of the block for each page of events' do
      expect(journal_events_repository).to receive(:from).with(3)
      expect(journal_events_repository).to receive(:from).with(7)
      expect(in_block_code).to receive(:call).with(AllegroApi::JournalEvent).exactly(8).times
      event_ids = []
      journal_events_repository.each {|event| event_ids  << event.id; in_block_code.call(event) }
      expect(event_ids).to eq([0,1,2,3,4,5,6,7])
      expect(journal_events_repository.size).to eq(8)
    end
  end

  describe '#count_site_journal_events' do
    context 'without specifying start point' do
      it 'invokes doGetSiteJournalInfo SOAP request' do
        expect(client).to receive(:call).with(:do_get_site_journal_info, session_handle: 1234).and_return(
            {do_get_site_journal_info_response: {site_journal_info: {items_number: 0, last_item_date: 0}}})
        journal_events_repository.size
      end
    end

    context 'with starting point' do
      it 'invokes doGetSiteJournalInfo SOAP request' do
        expect(client).to receive(:call).with(:do_get_site_journal_info, session_handle: 1234,
            starting_point: 4321).and_return(
            {do_get_site_journal_info_response: {site_journal_info: {items_number: 0, last_item_date: 0}}})
        journal_events_repository.from(4321).size
      end
    end

    context 'on success' do
      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_site_journal_info_success'
      end

      subject{ journal_events_repository.size }

      it 'returns the number of events' do
        expect(subject).to eq 5
      end
    end
  end

  describe '#get_site_journal_events' do
    subject { journal_events_repository.to_a }

    context 'without specifying start point' do
      it 'invokes doGetSiteJournal SOAP request' do
        expect(journal_events_repository).to receive(:count_site_journal_events).and_return(1)
        expect(client).to receive(:call).with(:do_get_site_journal, session_handle: 1234).and_return(
          {do_get_site_journal_response: {site_journal_array: {item: [{row_id:1}]}}})
        subject
      end
    end

    context 'with starting point' do
      it 'invokes doGetSiteJournal SOAP request' do
        expect(journal_events_repository).to receive(:count_site_journal_events).and_return(1)
        expect(client).to receive(:call).with(:do_get_site_journal, session_handle: 1234,
          starting_point: 4321).and_return(
          {do_get_site_journal_response: {site_journal_array: {item: [{row_id:1}]}}})
        journal_events_repository.from(4321).to_a
      end
    end

    context 'on success' do
      # let(:events) { session.get_site_journal_events }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_site_journal_success'
      end

      it 'returns an array of journal events' do
        expect(journal_events_repository).to receive(:count_site_journal_events).and_return(5)
        expect(subject).to be_instance_of Array
        expect(subject.size).to eq 5
        expect(subject).to all(be_instance_of AllegroApi::JournalEvent)
      end
    end

    context 'on success without events' do
      # let(:events) { session.get_site_journal_events }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_site_journal_no_events'
      end

      it 'returns an empty array' do
        expect(journal_events_repository).to receive(:count_site_journal_events).and_return(0)
        expect(subject).to be_instance_of Array
        expect(subject.size).to eq 0
      end
    end
  end

end
