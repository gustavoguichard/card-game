namespace :db do
  desc "It'll clean all the nil evaluations that are older than 5 hours"
  task clean_nil_evaluations: :environment do
    Evaluation.where(data: nil).each do |nil_data|
      nil_data.destroy if nil_data.updated_at <= Time.now - 5.hours
    end
  end
end
