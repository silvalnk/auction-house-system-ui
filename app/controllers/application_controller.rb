class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern unless Rails.env.test?

  helper_method :current_participant

  def current_participant
    @current_participant ||= Participant.find_by(id: session[:participant_id]) || Participant.order(:name).find_by(role: "bidder")
  end
end
