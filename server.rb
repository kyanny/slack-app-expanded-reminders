require 'sinatra'
require_relative 'app'
require 'json'

post '/' do
  app = App.new

  content_type 'application/json'
  
  app.get_expanded_reminders.to_json
end

post '/action' do
  app = App.new

  content_type 'application/json'

  reminder_id = JSON.parse(params['payload'])['actions'][0]['value']

  app.complete_reminder(reminder_id)

  app.get_expanded_reminders.to_json
end