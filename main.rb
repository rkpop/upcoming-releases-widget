require_relative 'Config'
require_relative 'calendar'
require_relative 'parser'

def main
  keystore = Config.new('config.toml')
  cal_conf = keystore.calendar_conf
  calendar = Google::Calendar.new(client_id: cal_conf[:client_id],
                                  client_secret: cal_conf[:client_secret],
                                  calendar: cal_conf[:calendar_id],
                                  redirect_url: 'urn:ietf:wg:oauth:2.0:oob',
                                  refresh_token: cal_conf[:refresh_token])
  time = current_time
  response = request(time)
  result = parse(response)
  puts result
  upload(calendar, result)
end

main if $PROGRAM_NAME == __FILE__
