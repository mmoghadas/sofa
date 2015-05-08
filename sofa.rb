require 'net/http'
require 'uri'
require 'json'

class Sofa

  attr_reader :uri

  def initialize(url)
    @uri = URI.parse(url)
  end

  def request(req)
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
      request(req).body
    else
    request(req)
    end
  end

  def random_data(db, name='http_', count=2)
    available_status = %w(healthy unhealthy)

    count.times do |c|
      service_name = name + c.to_s
      status = {'status'=>available_status.sample}

      begin
        record = sit(:get, "/#{db}/#{service_name}")
        rev = JSON.parse(record)['_rev']
        sit(:put, "/#{db}/#{service_name}", status.merge('_rev'=>rev).to_json)
      rescue
        sit(:put, "/#{db}/#{service_name}", status.to_json)
      end

    end
  end

  def handle_error(req, res)
    e = RuntimeError.new("#{res.code}:#{res.message}\nMETHOD: #{req.method}\nURI: #{uri}#{req.path}\n#{res.body}")
    raise e
  end

end
