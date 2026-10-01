# frozen_string_literal: true

class InertiaController < ApplicationController
  inertia_share participant: -> {
    current_participant&.as_json(only: %i[id name role])
  }
  inertia_share participants: -> {
    Participant.order(:name).as_json(only: %i[id name role])
  }
  inertia_share flash: -> {
    { alert: flash[:alert], notice: flash[:notice] }
  }
end
