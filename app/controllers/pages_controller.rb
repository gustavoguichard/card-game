class PagesController < ApplicationController
  before_filter :load_resources, only: [:game]

  def game
  end

  def questions
  end

  def new_game
    reset_session
    redirect_to root_path
  end

end