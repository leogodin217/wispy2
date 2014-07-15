class Cluster < ActiveRecord::Base

  belongs_to :front

  validates :name,   presence: true
  validates :status, presence: true
end
