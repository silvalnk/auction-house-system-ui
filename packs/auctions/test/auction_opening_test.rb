# frozen_string_literal: true

require "minitest/autorun"
require "dry/monads"
require_relative "../app/domain/auctions/money"
require_relative "../app/domain/auctions/auction_opened"
require_relative "../app/domain/auctions/bid_accepted"
require_relative "../app/domain/auctions/auction"

class AuctionOpeningTest < Minitest::Test
  def test_rails_is_not_loaded
    refute defined?(Rails)
  end

  def test_valid_publication_opens_at_the_starting_price
    result = open(starting_price_cents: 1000, ends_at: future)

    assert result.success?
    auction = result.value!
    assert_equal 1000, auction.current_price_cents
    assert_equal 1, auction.changes.length
    assert_instance_of Auctions::AuctionOpened, auction.changes.first
  end

  def test_zero_price_is_rejected
    result = open(starting_price_cents: 0, ends_at: future)

    assert result.failure?
    assert_equal :invalid_price, result.failure
  end

  def test_negative_price_is_rejected
    result = open(starting_price_cents: -1, ends_at: future)

    assert_equal :invalid_price, result.failure
  end

  def test_past_end_is_rejected
    result = open(starting_price_cents: 1000, ends_at: Time.utc(2020, 1, 1))

    assert_equal :ends_at_in_the_past, result.failure
  end

  private

  def future
    Time.utc(2030, 1, 1, 12)
  end

  def open(starting_price_cents:, ends_at:)
    Auctions::Auction.open(
      id: "auction-1",
      seller_id: "seller",
      title: "Relógio",
      starting_price_cents: starting_price_cents,
      ends_at: ends_at,
      now: Time.utc(2026, 10, 1, 12)
    )
  end
end
