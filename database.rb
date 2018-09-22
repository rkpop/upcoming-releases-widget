# frozen_string_literal: true

require 'sqlite3'

# Database class
# Entry checking, and inserting is done in this class
class Database
  def initialize(database_name)
    @instance = SQLite3::Database.new database_name
  end

  def check_entry(entry_name)
    result = nil
    @instance.execute('select * from entries where title = ? LIMIT 1',
                      entry_name) do |row|
                        result = row[0] unless row.nil?
                      end
    result
  end

  def add_entry(entry)
    @instance.execute('insert into entries (cal_id, title) VALUES (?, ?)',
                      [entry[:cal_id], entry[:title]])
  end
end
