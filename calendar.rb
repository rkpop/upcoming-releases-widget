require 'google_calendar'
require_relative 'time_wrapper'
require 'time'

def generate_calendar(entry)
  title = "#{entry[:artist_name]} - #{entry[:album_title]}"
  month_year = current_time
  start_time = Time.new(month_year[:year],
                        month_year[:month],
                        entry[:release_date],
                        entry[:release_time][:hour],
                        entry[:release_time][:minute],
                        0,
                        '+09:00')
  end_time = start_time + 3600
  final_structure = {title: title,
                     start_time: start_time,
                     end_time: end_time}
  final_structure
end

def upload(config, data)
  calendar = Google::Calendar.new(client_id: config[:client_id],
                                  client_secret: config[:client_secret],
                                  calendar: config[:calendar_id],
                                  redirect_url: 'urn:ietf:wg:oauth:2.0:oob',
                                  refresh_token: config[:refresh_token])
  data.each do |entry|
    proper_entry = generate_calendar(entry)
    event_id = calendar.create_event do |e|
      e.title = proper_entry[:title]
      e.start_time = proper_entry[:start_time]
      e.end_time = proper_entry[:end_time]
    end
    puts event_id
  end
end
