class EvaluationsController < ApplicationController
  respond_to :html, :json

  def index
    @evaluations = Evaluation.all
  end

  def show
    @evaluation = current_evaluation
  end

  def new
    @evaluation = current_evaluation
  end

  def create
    @evaluation = Evaluation.new(evaluation_params)
    if @evaluation.save
      redirect_to results_path, notice: 'You were successfully registrated.'
    else
      render action: "new"
    end
  end

  def update
    @evaluation = Evaluation.find(params[:id])
    @evaluation.update_attributes(evaluation_params)
    redirect_to results_path, notice: 'You were successfully registrated.'
  end

  def destroy
    @evaluation = Evaluation.find(params[:id])
    @evaluation.destroy
    redirect_to evaluations_url
  end

private
  
  def evaluation_params
    params[:evaluation].permit(:name, :city, :email, :state, :data)
  end

end