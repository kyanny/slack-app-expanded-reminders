require 'sinatra'
require_relative 'app'

post '/' do
  #'Hello from Expanded reminders'
  app = App.new
  app.get_expanded_reminders
end
