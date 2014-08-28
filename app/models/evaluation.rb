class Evaluation < ActiveRecord::Base
  validates :email, uniqueness: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Email must be valid"}, allow_blank: true
end