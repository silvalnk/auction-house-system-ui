# frozen_string_literal: true

module Auctions
  class Status
    include Import["ping"]

    def call
      ping.call
    end
  end
end
