require 'sinatra'
require_relative 'app'
require 'json'

post '/' do

  app = App.new

  content_type 'application/json'
  
  app.get_expanded_reminders.to_json
end
