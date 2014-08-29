class EvaluationMailer < ActionMailer::Base
  default from: "gustavoguichard@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.evaluation_mailer.results_confirmation.subject
  #
  def results_confirmation(evaluation, root_url)
    @evaluation = evaluation
    @root_url = root_url
    mail to: evaluation.email, subject: "Check your game results"
  end
end