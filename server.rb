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

  require 'pp'
  pp params
  puts '='*80
  puts params
  'wip'
  #reminder_id = params['']
  #app.complete_reminder()
end