# frozen_string_literal: true

require 'sqlite3'
require_relative 'config'

config = Config.new(File.dirname(__FILE__) + '/config.toml').sqlite_conf

db = SQLite3::Database.new(config)
db.execute <<-SQL
  create table entries (
    cal_id VARCHAR(50),
    title VARCHAR(280)
  );
SQL
