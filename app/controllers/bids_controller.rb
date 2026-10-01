# frozen_string_literal: true

class BidsController < InertiaController
  include AuctionMessages

  def create
    result = Auctions.place_bid(
      auction_id: params[:auction_id],
      bidder_id: current_participant.id,
      amount_cents: integer_param(params[:amount_cents])
    )

    if result.success?
      redirect_to auction_path(params[:auction_id])
    else
      redirect_to auction_path(params[:auction_id]), flash: { alert: auction_message(result.failure) }
    end
  end

  private

  def integer_param(value)
    Integer(value)
  rescue ArgumentError, TypeError
    0
  end
end
