# frozen_string_literal: true

require 'tomlrb'

# class APIKeys
# Parses TOML file with the API Keys for Google Calendar and SQLite
# returns HashTable
class Config
  def initialize(filename)
    @config = Tomlrb.load_file(filename, symbolize_keys: true)
  end

  def calendar_conf
    @config[:google]
  end

  def sqlite_conf
    @config[:sqlite]
  end
end
