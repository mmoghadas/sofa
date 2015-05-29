json.array!(@watchdogs) do |watchdog|
  json.extract! watchdog, :id, :name, :state
  json.url watchdog_url(watchdog, format: :json)
end
