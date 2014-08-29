class EvaluationMailer < ActionMailer::Base
  default from: "gustavoguichard@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.evaluation_mailer.results_confirmation.subject
  #
  def results_confirmation(evaluation)
    @evaluation = evaluation
    mail to: evaluation.email, subject: "Check your game results"
  end
end