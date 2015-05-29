class Watchdog
  include Mongoid::Document
  field :name, type: String
  field :state, type: String
end
