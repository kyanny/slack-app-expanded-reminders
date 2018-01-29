require 'sinatra'
require_relative 'app'
require 'json'

get '/' do
end

get '/callback' do
  res = Slack::Web::Client.new.oauth_access(
    client_id: ENV.fetch('SLACK_APP_CLIENT_ID'),
    client_secret: ENV.fetch('SLACK_APP_CLIENT_SECRET'),
    code: params['code'],
  )
  pp res
end

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