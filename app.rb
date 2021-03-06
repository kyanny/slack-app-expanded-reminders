require 'slack-ruby-client'
require 'pp'

class App
    def initialize(access_token: nil)
        if access_token
            Slack.configure do |config|
                config.token = access_token
            end
        end
        @client = Slack::Web::Client.new
    end
    
    attr_reader :client

    def get_expanded_reminders
        reminders = client.reminders_list.reminders
        reminders = reminders.reject { |reminder|
            reminder.complete_ts != 0
        }.map { |reminder|
            if m = reminder.text.match(%r!\Ahttps://quipper\.slack\.com/archives/([^/]*)/p([^/]*)\?thread_ts=(.*)&cid=(.*)\z!)
                channel   = m[1]
                ts        = m[2].to_f / 1000000
                thread_ts = m[3].to_f / 1000000
                res = client.conversations_replies(channel: channel, inclusive: true, ts: thread_ts, latest: ts, limit: 1)
                text = res.messages.last.text
                [reminder.text, text, reminder.id]
            elsif m = reminder.text.match(%r!\Ahttps://quipper\.slack\.com/archives/([^/]*)/p([^/]*)\z!)
                channel = m[1]
                ts      = m[2].to_f / 1000000
                res = client.conversations_history(channel: channel, inclusive: true, latest: ts+0.000001, limit: 1)
                if res.messages.first.subtype == 'file_share'
                    text = res.messages.first.file.preview
                    [reminder.text, text, reminder.id]
                else
                    text = res.messages.first.text
                    [reminder.text, text, reminder.id]
                end
            end
        }

        {
            text: "Expanded reminders",
            attachments: reminders.map { |(text, message, reminder_id)|
                msg = "<#{text}|this message> #{message}"
                {
                    text: msg,
                    fallback: msg,
                    callback_id: '0',
                    actions: [
                        {
                            name: "complete",
                            text: "Complete",
                            type: "button",
                            value: reminder_id,
                        }
                    ]
                }
            }
        }
    end

    def complete_reminder(id)
        res = client.reminders_complete(reminder: id)
        res.ok
    end
end

if __FILE__ == $0
    Slack.configure do |config|
        config.token = ENV.fetch('SLACK_API_TOKEN')
    end
    #pp App.new.get_expanded_reminders
    #puts JSON.pretty_generate(App.new.get_expanded_reminders)
end
