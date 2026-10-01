# frozen_string_literal: true

module AuctionMessages
  MESSAGES = {
    invalid_price: "Informe um preço inicial maior que zero.",
    ends_at_in_the_past: "O término precisa estar no futuro.",
    seller_cannot_bid: "O vendedor não pode dar lance no próprio leilão.",
    auction_ended: "O leilão já terminou.",
    bid_too_low: "O lance precisa ser maior que o preço atual.",
    conflict: "Outro lance foi confirmado antes. Tente de novo.",
    not_found: "Leilão não encontrado."
  }.freeze

  def auction_message(code)
    MESSAGES.fetch(code, "Não foi possível concluir.")
  end
end
