require 'sinatra'
require_relative 'app'
require 'json'

post '/' do
  #'Hello from Expanded reminders'
  app = App.new
  app.get_expanded_reminders.to_s

  {
    "text": "New comic book alert! _The Further Adventures of Slackbot_, Volume 1, Issue 3."
  }.to_json
end
