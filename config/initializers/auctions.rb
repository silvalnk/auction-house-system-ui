# frozen_string_literal: true

Rails.configuration.event_store = RailsEventStore::JSONClient.new

Rails.application.config.to_prepare do
  Auctions.boot(
    event_store: Rails.configuration.event_store,
    publisher: AuctionBroadcaster.new
  )
end
