# frozen_string_literal: true

class HomeController < InertiaController
  def index
    render inertia: "home/index", props: { auctions: Auctions.list_listings }
  end
end
