# frozen_string_literal: true

require 'google_calendar'
require './time_wrapper'
require './database'
require 'time'

# Calendar class
# Main calendar update/upload implementation
class Calendar
  def initialize(calendar_instance, database_instance)
    @calendar = calendar_instance
    @database = database_instance
  end

  def add_entry(data)
    data.each do |entry|
      proper_entry = generate_calendar(entry)
      cal_id = @database.check_entry(proper_entry[:title])
      if cal_id.nil?
        upload proper_entry
      else
        update cal_id, proper_entry
      end
    end
  end

  private

  def generate_calendar(entry)
    title = "#{entry[:artist_name]} - #{entry[:album_title]}"
    start_time = generate_time(entry)
    final_structure = { title: title,
                        start_time: start_time,
                        end_time: start_time + 3600,
                        description: entry[:album_type] }
    final_structure
  end

  def generate_time(entry)
    time = Time.new(current_time[:year],
                    current_time[:month],
                    entry[:release_date],
                    entry[:release_time][:hour],
                    entry[:release_time][:minute],
                    0,
                    '+09:00')

    time
  end

  def upload(proper_entry)
    event_id = @calendar.create_event do |e|
      e.title = proper_entry[:title]
      e.start_time = proper_entry[:start_time]
      e.end_time = proper_entry[:end_time]
      e.description = proper_entry[:description]
    end
    database_input = { cal_id: event_id.id, title: proper_entry[:title] }
    @database.add_entry(database_input)
  end

  def update(id, proper_entry)
    @calendar.find_or_create_event_by_id(id) do |e|
      e.start_time = proper_entry[:start_time]
      e.end_time = proper_entry[:end_time]
    end
  end
end
