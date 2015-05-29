require 'net/http'
require 'uri'
require 'json/ext'
require 'couchrest'
require 'mongo'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  attr_reader :uri, :db

  def get_nothing
    render text: 'nothing'
  end

  def post_nothing
    render text: 'nothing'
  end

  def curl_get_example
    data = sit(:get, '/prod')
    render json: data
  end

  ########################
  #  Couch               #
  ########################

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
    id = params['_id']
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

  ########################
  #  Mongo               #
  ########################

  def get_state_mongo
    if params['name']
      get_service_health_mongo
    else
      get_all_health_state_mongo
    end
  end

  def get_service_health_mongo
    name = params['name']
    data = mongo.find(name: name).first
    result = "#{data[:name]} : #{data[:state]}"
    render json: result
  end

  def get_all_health_state_mongo
    result = "you need to pass parameter 'name'"
    render json: result
  end

  def get_healthy_mongo
    display_mongo('healthy')
  end

  def get_unhealthy_mongo
    display_mongo('unhealthy')
  end

  def display_mongo(state)
    data = mongo.find(:state => /^#{state}$/i)
    results = data.map{|w| "#{w[:name]} : #{w[:state]}"}
    results.insert(0, results.count)
    render json: results
  end

  def update_state_mongo
    name = params['name']
    state = params['state']

    mongo.find(name: name).update_one({name: name, state: state}, upsert: true)

    render text: "Thanks for sending a POST request with cURL! Payload: #{request.body.read}"
  end

  private

  def url
    'http://127.0.0.1:5984/prod'
  end

  def uri
    @uri ||= URI.parse(url)
  end

  def db
    @db ||= CouchRest.database(url)
  end

  def http_request(req)
    response = Net::HTTP.new(uri.host, uri.port).request(req)
    case response
    when Net::HTTPSuccess
      response
    when Net::HTTPUnauthorized
      puts "catch unauthorized here.."
    else
      handle_error(req, response)
    end
  end

  def sit(method, path, json=nil)
    http_methods = {
      get:    Net::HTTP::Get,
      post:   Net::HTTP::Post,
      put:    Net::HTTP::Put,
      delete: Net::HTTP::Delete
    }

    req = http_methods[method].new(path, initheader = {'Content-Type' => "application/json"})
    req.body = json

    if method == :get
      http_request(req).body
    else
    http_request(req)
    end
  end

  def random_data(db, name='http_', count=2)
    available_state = %w(healthy unhealthy)

    count.times do |c|
      service_name = name + c.to_s
      state = {'state'=>available_state.sample}

      begin
        record = sit(:get, "/#{db}/#{service_name}")
        rev = JSON.parse(record)['_rev']
        sit(:put, "/#{db}/#{service_name}", state.merge('_rev'=>rev).to_json)
      rescue
        sit(:put, "/#{db}/#{service_name}", state.to_json)
      end

    end
  end

  def show_all_designs(db)
    data = sit(:get, "/#{db}/_all_docs?startkey=\"_design/\"&endkey=\"_design0\"")
    JSON.parse(data)['rows'][0]['id'].split('/').last
    designs = JSON.parse(data)['rows'].map{|r|r['id'].split('/').last}
    designs.each{|d|print sit(:get, "/prod/_design/#{d}")}
  end

  def get_view(db, design, view)
    data = sit(:get, "/#{db}/_design/#{design}/_view/#{view}")
  end

  def get_all_docs(db)
    data = sit(:get, "/#{db}/_all_docs")
    JSON.parse(data)['rows'].map{|record|record['id']}
  end

  def handle_error(req, res)
    e = RuntimeError.new("#{res.code}:#{res.message}\nMETHOD: #{req.method}\nURI: #{uri}#{req.path}\n#{res.body}")
    raise e
  end

  def mongo
    Mongo::Logger.logger.level = Logger::WARN
    mongodb_host = ENV['MONGODB_HOST'] ? ENV['MONGODB_HOST'] : '127.0.0.1:27017'
    Mongo::Client.new([ mongodb_host ], :database => 'prod')[:watchdogs]
  end

end
