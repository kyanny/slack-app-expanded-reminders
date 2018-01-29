require 'sinatra'
require_relative 'app'
require 'redis'
require 'json'

get '/' do
  client_id = ENV.fetch('SLACK_APP_CLIENT_ID')
  scope = ENV.fetch('SLACK_APP_SCOPE')
  @href = "https://slack.com/oauth/authorize?client_id=%s&scope=%s" % [client_id, scope]
  erb :index
end

get '/callback' do
  redis = Redis.new
  if redis.get('access_token')
    'not ok'
    return
  end
  
  client_id = ENV.fetch('SLACK_APP_CLIENT_ID')
  client_secret = ENV.fetch('SLACK_APP_CLIENT_SECRET')

  res = Slack::Web::Client.new.oauth_access(
    client_id: client_id,
    client_secret: client_secret,
    code: params['code'],
  )
  
  redis.set('access_token', res['access_token'])

  'ok'
end

post '/' do
  redis = Redis.new
  access_token = redis.get('access_token')

  app = App.new(access_token: access_token)

  content_type 'application/json'
  
  app.get_expanded_reminders.to_json
end

post '/action' do
  redis = Redis.new
  access_token = redis.get('access_token')

  app = App.new(access_token: access_token)

  content_type 'application/json'

  reminder_id = JSON.parse(params['payload'])['actions'][0]['value']

  app.complete_reminder(reminder_id)

  app.get_expanded_reminders.to_json
end