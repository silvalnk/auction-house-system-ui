# frozen_string_literal: true

require "minitest/autorun"
require "dry/monads"
require_relative "../app/domain/auctions/money"
require_relative "../app/domain/auctions/auction_opened"
require_relative "../app/domain/auctions/bid_accepted"
require_relative "../app/domain/auctions/auction"

class AuctionBiddingTest < Minitest::Test
  def test_rails_is_not_loaded
    refute defined?(Rails)
  end

  def test_first_higher_bid_becomes_the_price
    auction = opened
    result = auction.place_bid(bidder_id: "ana", amount_cents: 1500, now: now)

    assert result.success?
    assert_equal 1500, auction.current_price_cents
  end

  def test_following_higher_bid_replaces_the_price
    auction = opened
    auction.place_bid(bidder_id: "ana", amount_cents: 1500, now: now)
    result = auction.place_bid(bidder_id: "bruno", amount_cents: 1800, now: now)

    assert result.success?
    assert_equal 1800, auction.current_price_cents
  end

  def test_equal_bid_does_not_change_the_price
    auction = opened
    result = auction.place_bid(bidder_id: "ana", amount_cents: 1000, now: now)

    assert_equal :bid_too_low, result.failure
    assert_equal 1000, auction.current_price_cents
  end

  def test_lower_bid_does_not_change_the_price
    auction = opened
    result = auction.place_bid(bidder_id: "ana", amount_cents: 900, now: now)

    assert_equal :bid_too_low, result.failure
    assert_equal 1000, auction.current_price_cents
  end

  def test_seller_cannot_bid
    auction = opened
    result = auction.place_bid(bidder_id: "seller", amount_cents: 1500, now: now)

    assert_equal :seller_cannot_bid, result.failure
    assert_equal 1000, auction.current_price_cents
  end

  def test_bid_after_the_end_is_rejected
    auction = opened
    result = auction.place_bid(bidder_id: "ana", amount_cents: 1500, now: Time.utc(2030, 1, 2))

    assert_equal :auction_ended, result.failure
    assert_equal 1000, auction.current_price_cents
  end

  private

  def now
    Time.utc(2026, 10, 1, 12)
  end

  def opened
    Auctions::Auction.open(
      id: "auction-1",
      seller_id: "seller",
      title: "Relógio",
      starting_price_cents: 1000,
      ends_at: Time.utc(2030, 1, 1, 12),
      now: now
    ).value!
  end
end
