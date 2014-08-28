class Evaluation < ActiveRecord::Base
  validates :email, uniqueness: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Email must be valid"}, allow_blank: true

  def results_for(pile, cards)
    results = {}
    starred_cards = data.select{|card| card['pile'] == pile and card['starred'] == true}
    cards.group_by{|c| c[:action]}.each do |group|
      ids = group[1].map{|oc| oc[:id]}
      starred_ids = starred_cards.map{|sc| sc['id'] if ids.include?(sc['id'])}
      action_cards = cards.select{|ac| starred_ids.include?(ac[:id])}
      unless action_cards.empty?
        results[group[0]] = action_cards
      end
    end
    results
  end

end