class Evaluation < ActiveRecord::Base
  validates :email, presence: {message: "Email is not valid."},
                  format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Email must be valid"},
                  allow_blank: true,
                  uniqueness: { :case_sensitive => false },
                  allow_nil: true,
                  :if => :email?

  def results
    results = {}
    %w(core adjacent aspirational out-of-bounds).each do |pile|
      pile_results = {}
      if starred_from_pile(pile)
        StaticData::GAME_CARDS.group_by{|c| c[:action]}.each do |group|
          ids = group[1].map{|oc| oc[:id]}
          starred_ids = starred_from_pile(pile).map{|sc| sc['id'] if ids.include?(sc['id'])}
          action_cards = StaticData::GAME_CARDS.select{|ac| starred_ids.include?(ac[:id])}
          unless action_cards.empty?
            pile_results[group[0]] = action_cards
          end
        end
      end
      results[pile] = pile_results
    end
    results
  end

  def self.to_csv
    CSV.generate do |csv|
      header_names = %w(ID Name Email\ Address Timestamp City State Group\ Code Priority\ Level Role Category\ of\ Role)
      csv << header_names
      all.each do | evaluation |
        if evaluation.starred_cards
          evaluation.starred_cards.each do | card |
            results = []
            index = card['id'] - 1
            results.push(evaluation.id, evaluation.name, evaluation.email)
            results.push(evaluation.created_at.strftime("%a %b %d, %Y, %l:%M:%S %p"))
            results.push(evaluation.city, evaluation.state, evaluation.keyword)
            results.push(card['pile'])
            results.push(StaticData::GAME_CARDS[index][:title], StaticData::GAME_CARDS[index][:action])
            csv << results
          end
        end
      end
    end
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

  def starred_cards
    data.select{|card| card['starred'] == true}.sort_by{|card| card['pile'].length} if data
  end

  def starred_from_pile(pile)
    starred_cards.select{|card| card['pile'] == pile} if starred_cards
  end

end