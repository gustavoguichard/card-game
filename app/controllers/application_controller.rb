class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_evaluation

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

end
