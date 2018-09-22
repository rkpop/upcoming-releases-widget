require_relative 'config'
require_relative 'calendar'
require_relative 'database'
require_relative 'parser'

def main
  config = Config.new('config.toml')
  cal_conf = config.calendar_conf
  gcal = Google::Calendar.new(client_id: cal_conf[:client_id],
                              client_secret: cal_conf[:client_secret],
                              calendar: cal_conf[:calendar_id],
                              redirect_url: 'urn:ietf:wg:oauth:2.0:oob',
                              refresh_token: cal_conf[:refresh_token])
  database = Database.new(config.sqlite_conf[:database_name])
  calendar = Calendar.new(gcal, database)
  time = current_time
  response = request(time)
  result = parse(response)
  calendar.add_entry(result)
end

main if $PROGRAM_NAME == __FILE__
