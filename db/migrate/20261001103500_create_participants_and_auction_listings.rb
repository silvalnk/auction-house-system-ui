# frozen_string_literal: true

class CreateParticipantsAndAuctionListings < ActiveRecord::Migration[8.1]
  def change
    enable_extension "pgcrypto"

    create_table :participants, id: :uuid do |t|
      t.string :name, null: false
      t.string :role, null: false
      t.timestamps
    end

    create_table :auction_listings, id: :uuid do |t|
      t.uuid :seller_id, null: false
      t.string :title, null: false
      t.datetime :ends_at, null: false
      t.integer :current_price_cents, null: false
      t.boolean :open, null: false, default: true
      t.timestamps
    end
  end
end
