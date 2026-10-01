# frozen_string_literal: true

class AuctionsController < InertiaController
  include AuctionMessages

  def new
    render inertia: "auctions/new"
  end

  def create
    result = Auctions.create_auction(
      seller_id: current_participant.id,
      title: auction_params[:title],
      starting_price_cents: integer_param(auction_params[:starting_price_cents]),
      ends_at: parsed_time(auction_params[:ends_at])
    )

    if result.success?
      redirect_to auction_path(result.value![:id])
    else
      redirect_to new_auction_path, flash: { alert: auction_message(result.failure) }
    end
  end

  def show
    listing = Auctions.find_listing(params[:id])
    return head :not_found unless listing

    render inertia: "auctions/show", props: { auction: listing }
  end

  private

  def auction_params
    params.permit(:title, :starting_price_cents, :ends_at)
  end

  def integer_param(value)
    Integer(value)
  rescue ArgumentError, TypeError
    0
  end

  def parsed_time(value)
    Time.zone.parse(value.to_s)
  rescue ArgumentError, TypeError
    nil
  end
end
