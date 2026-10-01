# frozen_string_literal: true

require "test_helper"

class AuctionsRequestTest < ActionDispatch::IntegrationTest
  setup do
    @seller = Participant.create!(name: "Vendedor", role: "seller")
    @ana = Participant.create!(name: "Ana", role: "bidder")
    @bruno = Participant.create!(name: "Bruno", role: "bidder")
  end

  test "pages publish a valid auction and refuse a bid that does not raise the price" do
    post session_path, params: { participant_id: @seller.id }
    post auctions_path, params: {
      title: "Relógio",
      starting_price_cents: 1000,
      ends_at: 2.days.from_now.iso8601
    }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    auction_id = Auctions::ListingRecord.order(:created_at).last.id
    assert_includes response.body, "Relógio"

    post session_path, params: { participant_id: @ana.id }
    post auction_bids_path(auction_id), params: { amount_cents: 1500 }
    assert_response :redirect
    follow_redirect!
    assert_includes response.body, "1500"

    post auction_bids_path(auction_id), params: { amount_cents: 1500 }
    assert_response :redirect
    follow_redirect!
    assert_includes response.body, "O lance precisa ser maior que o preço atual."
    assert_equal 1500, Auctions.find_listing(auction_id)[:current_price_cents]
  end
end