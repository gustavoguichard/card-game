class EvaluationsController < ApplicationController

  def index
    @evaluations = Evaluation.all
  end

  def show
    @evaluation = Evaluation.find(params[:id])
  end

  def new
    city = request.location.city || 'Unknown'
    state = request.location.data['region_name'] || 'Unknown'
    @evaluation = Evaluation.new(city: city, state: state)
  end

  def create
    @evaluation = Evaluation.new(params[:evaluation])
    if @evaluation.save
      redirect_to results_path, notice: 'You were successfully registrated.'
    else
      render action: "new"
    end
  end

  def update
    @evaluation = Evaluation.find(params[:id])
    @evaluation.update_attributes(params[:evaluation])
    respond_with @evaluation
  end

  def destroy
    @evaluation = Evaluation.find(params[:id])
    @evaluation.destroy
    redirect_to evaluations_url
  end

end