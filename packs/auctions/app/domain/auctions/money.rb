# frozen_string_literal: true

module Auctions
  class Money
    attr_reader :cents

    def initialize(cents)
      @cents = cents
    end

    def positive?
      cents.is_a?(Integer) && cents.positive?
    end
  end
end
