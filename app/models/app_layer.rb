class AppLayer < ActiveRecord::Base
  validates :app_layer, presence: true
end
