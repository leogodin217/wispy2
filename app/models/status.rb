class Status < ActiveRecord::Base
  validates :status, presence: true
end
