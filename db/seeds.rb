# frozen_string_literal: true

Participant.find_or_create_by!(name: "Vendedor") { |participant| participant.role = "seller" }
Participant.find_or_create_by!(name: "Ana") { |participant| participant.role = "bidder" }
Participant.find_or_create_by!(name: "Bruno") { |participant| participant.role = "bidder" }
