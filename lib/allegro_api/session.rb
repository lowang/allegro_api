module AllegroApi
  class Session
    attr_reader :login
    attr_reader :client
    attr_reader :id
    attr_reader :user_id

    def initialize(client, id, user_id)
      @client = client
      @id = id
      @user_id = user_id
    end

    def auctions
      AllegroApi::Repository::Auction.new(self)
    end

    def categories
      AllegroApi::Repository::Category.new(self)
    end

    def deal_events
      AllegroApi::Repository::DealEvent.new(self)
    end

    def items
      AllegroApi::Repository::Item.new(self)
    end

    def journal_events
      AllegroApi::Repository::JournalEvent.new(self)
    end

    def purchase_details
      AllegroApi::Repository::PurchaseDetail.new(self)
    end

    def transactions
      AllegroApi::Repository::Transaction.new(self)
    end

  end
end
