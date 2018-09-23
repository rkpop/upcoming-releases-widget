# frozen_string_literal: true

require './config'
require './calendar'
require './database'
require './parser'

def main
  config = Config.new('config.toml')
  cal_conf = config.calendar_conf
  calendar = Calendar.new(create_gcal(cal_conf),
                          Database.new(config.sqlite_conf[:database_name]))
  time = current_time
  response = request(time)
  result = parse(response)
  calendar.add_entry(result)
end

def create_gcal(cal_conf)
  gcal = Google::Calendar.new(client_id: cal_conf[:client_id],
                              client_secret: cal_conf[:client_secret],
                              calendar: cal_conf[:calendar_id],
                              redirect_url: 'urn:ietf:wg:oauth:2.0:oob',
                              refresh_token: cal_conf[:refresh_token])

  gcal
end

main if $PROGRAM_NAME == __FILE__
