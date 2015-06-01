require 'couchrest'

class CouchrestController < ApplicationController

  attr_reader :db

  def get_state
    if params['name']
      get_service_health
    else
      get_all_health_state
    end
  end

  def get_service_health
    name = params['name']
    data = db.get(name)
    result = "#{data['_id']} : #{data['state']}"
    render json: result
  end

  def get_all_health_state
    result = "you need to pass parameter 'name'"
    render json: result
  end

  def get_healthy
    display('healthy')
  end

  def get_unhealthy
    display('unhealthy')
  end

  def display(state)
    data = db.view("state/#{state}")['rows']
    results = data.map{|r| "#{r['id']} : #{r['value']}"}
    results.insert(0, results.count)
    render json: results
  end

  def update_state
    id = params['name']
    state = params['state']

    data = {'_id'=>id, 'state'=>state}
    # CouchRest.put("#{url}/#{id}", data)
    begin
      CouchRest.put("#{url}/#{id}", data)
    rescue
      record = get_record(id)
      CouchRest.put("#{url}/#{id}", data.merge('_rev'=>record['_rev']))
    end
    render text: "Thanks for sending a POST request with cURL! Payload: #{request.body.read}"
  end

  def get_record(id)
    begin
      CouchRest.get("#{url}/#{id}")
    rescue
    end
  end

  private

  def url
    'http://127.0.0.1:5984/prod'
  end

  def db
    @db ||= CouchRest.database(url)
  end

end
