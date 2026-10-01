# frozen_string_literal: true

module Auctions
  class SystemClock
    def now
      Time.current
    end
  end
end
