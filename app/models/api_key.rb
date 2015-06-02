class ApiKey
  include Mongoid::Document
  before_create :generate_access_token

  field :access_token, type: String

  private
  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end
  end
end
