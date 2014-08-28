class PagesController < ApplicationController
  before_filter :load_resources, only: [:game]

  def game
  end

  def questions
  end

end