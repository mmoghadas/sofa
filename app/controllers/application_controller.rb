require 'net/http'
require 'uri'
require 'json/ext'
require 'couchrest'
require 'mongo'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def get_nothing
    render text: 'nothing'
  end

  def post_nothing
    render text: 'nothing'
  end

  private

end
