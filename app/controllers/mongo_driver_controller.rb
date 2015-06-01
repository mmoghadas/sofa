require 'mongo'

class MongoDriverController < ApplicationController
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

  def mongo
    Mongo::Logger.logger.level = Logger::WARN
    mongodb_host = ENV['MONGODB_HOST'] ? ENV['MONGODB_HOST'] : '127.0.0.1:27017'
    Mongo::Client.new([ mongodb_host ], :database => 'prod')[:watchdogs]
  end
end
