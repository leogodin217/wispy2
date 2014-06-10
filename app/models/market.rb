class Market < ActiveRecord::Base
  validates :market, presence: true
end
