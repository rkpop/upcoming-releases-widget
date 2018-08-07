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
  final_structure = { title: title,
                      start_time: start_time,
                      end_time: end_time,
                      description: entry[:album_type] }
  final_structure
end

def upload(calendar, data)
  data.each do |entry|
    proper_entry = generate_calendar(entry)
    event_id = calendar.create_event do |e|
      e.title = proper_entry[:title]
      e.start_time = proper_entry[:start_time]
      e.end_time = proper_entry[:end_time]
      e.description = proper_entry[:description]
    end
    puts event_id
  end
end
