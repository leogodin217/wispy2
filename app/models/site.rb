class Site < ActiveRecord::Base
  validates :site, presence: true
end
