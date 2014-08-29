class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_evaluation, :user_didnt_register?

private
  def current_evaluation
    Evaluation.find(session[:evaluation_id])
  rescue ActiveRecord::RecordNotFound
    city = request.location.city || 'Unknown'
    state = request.location.data['region_name'] || 'Unknown'
    evaluation = Evaluation.create(city: city, state: state)
    session[:evaluation_id] = evaluation.id
    evaluation
  end

  def user_didnt_register?
    current_evaluation.read_attribute(:name).blank? or current_evaluation.read_attribute(:email).blank?
  end

  def load_resources
    @cards = StaticData::GAME_CARDS
  end
end