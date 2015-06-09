class Watcher
  include CouchPotato::Persistence

  property :state

  view :healthy, key: :state
end