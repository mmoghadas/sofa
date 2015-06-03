class ApiKeyController < ApplicationController
  def generate
    watchdog_name = params['watchdog_name']
    key = ApiKey.create('watchdog_name'=>watchdog_name)
    token = key['access_token']
    render json: token
  end
end
