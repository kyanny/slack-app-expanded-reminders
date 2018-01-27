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

  puts '='*80
  puts '='*80
  # p params
  # puts '='*80
  # p params['payload']
  # puts '='*80
  # p params[:payload]
  json = JSON.parse(params['payload'])
  p json['actions'][0]['value']

  'wip'
  #reminder_id = params['']
  #app.complete_reminder()
end