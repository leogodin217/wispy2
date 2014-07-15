class Front < ActiveRecord::Base

  has_many :clusters

  validates :market,    presence: true
  validates :segment,   presence: true
  validates :site,      presence: true
  validates :app_layer, presence: true
  validates :pipe,      presence: true
  validates :status,     presence: true

  def full_name
    market +
    "-" +
    segment +
    "-" +
    site +
    "-" +
    app_layer +
    "-" +
    pipe
  end
end
