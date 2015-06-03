class ApiKey
  include Mongoid::Document
  before_create :generate_access_token

  field :access_token, type: String
  field :watchdog_name, type: String
  validates_presence_of :watchdog_name
  validates :watchdog_name, uniqueness: true

  private
  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end
  end
end
