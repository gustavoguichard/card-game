class EvaluationsController < ApplicationController
  respond_to :html, :json
  before_filter :load_resources, only: [:show]
  http_basic_authenticate_with name: ENV['ADMIN_USER'], password: ENV['ADMIN_PASSWORD'], only: [:index]

  def index
    @evaluations = Evaluation.paginate(page: params[:page], per_page: 30)
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def show
    if params[:id]
      @evaluation = Evaluation.find params[:id]
    else
      @evaluation = current_evaluation
    end
    @results = {}
    %w(core adjacent aspirational out-of-bounds).each do |pile|
      @results[pile] = @evaluation.results_for(pile, @cards)
    end
    respond_to do |format|
      format.html
      format.pdf {render :pdf => "results"}
    end
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
    params[:evaluation].permit(:name, :city, :email, :state, :data, :keyword)
  end

end