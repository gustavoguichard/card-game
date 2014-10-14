namespace :db do
  desc "It'll clean all the nil evaluations that are older than 5 hours"
  task clean_nil_evaluations: :environment do
    Evaluation.without_data.not_recent.each{|ev| ev.destroy}
  end

  desc "It'll clean all the evaluations with no starred cards, meaning no results output"
  task clean_blank_results: :environment do
    Evaluation.from_last_week.not_recent.with_blank_results.each{|ev| ev.destroy}
  end
end