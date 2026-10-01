# frozen_string_literal: true

class SessionsController < InertiaController
  def update
    participant = Participant.find_by(id: params[:participant_id])
    session[:participant_id] = participant.id if participant
    redirect_back fallback_location: root_path
  end
end
