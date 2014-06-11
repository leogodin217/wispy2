class Segment < ActiveRecord::Base
  validates :segment, presence: true
end
