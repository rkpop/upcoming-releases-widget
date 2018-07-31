require 'tomlrb'

# class APIKeys
# Parses TOML file with the API Keys for Google Calendar and Reddit
# returns HashTable
class Config
  def initialize(filename)
    @config = Tomlrb.load_file(filename, symbolize_keys: true)
  end

  def calendar_conf
    @config[:google]
  end
end
