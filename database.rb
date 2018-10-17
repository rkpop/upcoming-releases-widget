# frozen_string_literal: true

require 'sqlite3'

# Database class
# Entry checking, and inserting is done in this class
class Database
  def initialize(database_name)
    @instance = SQLite3::Database.new database_name
  end

  def check_entry(artist_name, release_time)
    result = nil
    @instance.execute('select * from entries where artist = ? AND release_time = ? LIMIT 1',
                      artist_name, release_time) do |row|
                        result = row[0] unless row.nil?
                      end
    result
  end

  def add_entry(entry)
    @instance.execute('insert into entries (cal_id, artist, release_time) VALUES (?, ?, ?)',
                      [entry[:cal_id], entry[:artist], entry[:mon_y]])
  end
end
