class EvaluationsController < ApplicationController
  respond_to :html, :json
  before_filter :load_resources, only: [:show, :index]
  http_basic_authenticate_with name: ENV['ADMIN_USER'], password: ENV['ADMIN_PASSWORD'], only: [:index]

  def index
    @evaluations = Evaluation.order(created_at: :desc).paginate(page: params[:page], per_page: 30)
    respond_to do |format|
      format.html
      format.csv { send_data Evaluation.all.to_csv, filename: 'MI_Game_Results.csv' }
    end
  end

  def show
    if params[:id]
      @evaluation = Evaluation.find params[:id]
    else
      @evaluation = current_evaluation
    end
    @results = @evaluation.results
    respond_to do |format|
      format.html
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
    mail_changed = (params[:evaluation][:email].present? and params[:evaluation][:email] != @evaluation.email)
    if @evaluation.update_attributes(evaluation_params)
      if mail_changed
        begin
          EvaluationMailer.results_confirmation(@evaluation).deliver
          flash[:success] = "Thank you! We are sending your personalized game results to your email address."
        rescue Net::SMTPAuthenticationError
          flash[:error] = "There was a problem and we couldn't send the results to your email. Please, try again later."
        end
      end
      redirect_to results_path
    else
      flash[:error] = "Email is invalid."
      render :new
    end
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