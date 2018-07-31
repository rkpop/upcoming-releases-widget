require 'sqlite3'
require_relative 'Config'

config = Config.new('config.toml').sqlite_conf

db = SQLite3::Database.new(config[:database_name])
db.execute <<-SQL
  create table entries (
    cal_id VARCHAR(50),
    title VARCHAR(280)
  );
SQL
