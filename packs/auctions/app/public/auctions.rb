# frozen_string_literal: true

require_relative "../../config/container"

module Auctions
  class << self
    def boot(event_store:, publisher:)
      return if Container.key?("create_auction")

      Container.register("event_store", memoize: true) { event_store }
      Container.register("publisher", memoize: true) { publisher }
      Container.register("clock", memoize: false) { SystemClock.new }
      Container.register("repository", memoize: false) { EventStoreRepository.new(event_store: Container["event_store"]) }
      Container.register("ping", memoize: false) { Ping.new }
      Container.register("status", memoize: false) { Status.new(ping: Container["ping"]) }
      Container.register("create_auction", memoize: false) do
        CreateAuction.new(repository: Container["repository"], clock: Container["clock"])
      end
      Container.register("place_bid", memoize: false) do
        PlaceBid.new(
          repository: Container["repository"],
          clock: Container["clock"],
          publisher: Container["publisher"]
        )
      end
      Container.register("listings", memoize: false) { Listings.new(clock: Container["clock"]) }
    end

    def container
      Container
    end

    def create_auction(...)
      Container["create_auction"].call(...)
    end

    def place_bid(...)
      Container["place_bid"].call(...)
    end

    def find_listing(id)
      Container["listings"].find(id)
    end

    def list_listings
      Container["listings"].list
    end
  end
end
