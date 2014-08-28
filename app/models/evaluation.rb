class Evaluation < ActiveRecord::Base
  validates :email, presence: {message: "Email is not valid."},
                  format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Email must be valid"},
                  allow_blank: true,
                  uniqueness: { :case_sensitive => false },
                  allow_nil: true,
                  :if => :email?

  def results_for(pile, cards)
    results = {}
    if data
      starred_cards = data.select{|card| card['pile'] == pile and card['starred'] == true}
      cards.group_by{|c| c[:action]}.each do |group|
        ids = group[1].map{|oc| oc[:id]}
        starred_ids = starred_cards.map{|sc| sc['id'] if ids.include?(sc['id'])}
        action_cards = cards.select{|ac| starred_ids.include?(ac[:id])}
        unless action_cards.empty?
          results[group[0]] = action_cards
        end
      end
    end
    results
  end

  def name
    if read_attribute(:name).blank?
      'Anonymous'
    else
      read_attribute(:name)
    end
  end

  def email
    if read_attribute(:email).blank?
      'Unknown'
    else
      read_attribute(:email)
    end
  end

  def city
    if read_attribute(:city).blank?
      'Unknown'
    else
      read_attribute(:city)
    end
  end

  def state
    if read_attribute(:state).blank?
      'Unknown'
    else
      read_attribute(:state)
    end
  end

end