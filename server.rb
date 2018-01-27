require 'sinatra'
require_relative 'app'
require 'json'

post '/' do
  #'Hello from Expanded reminders'
  app = App.new
  app.get_expanded_reminders.to_s

  content_type 'application/json'
  {
  "text": "<@W1A2BC3DD> approved your travel request. Book any airline you like by continuing below.",
  "channel": "C061EG9SL",
  "attachments": [
    {
      "fallback": "Book your flights at https://flights.example.com/book/r123456",
      "actions": [
        {
          "type": "button",
          "text": "Book flights 🛫",
          "url": "https://flights.example.com/book/r123456"
        }
      ]
    }
  ]
}.to_json
  
end
