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

  payload = params['payload']
  p payload
  pp JSON.parse(payload)

  'wip'
  #reminder_id = params['']
  #app.complete_reminder()
end