require_relative 'Config'
require_relative 'calendar'
require_relative 'parser'

def main
  keystore = Config.new('config.toml')
  cal_conf = keystore.calendar_conf
  time = current_time
  response = request(time)
  result = parse(response)
  puts result
  upload(cal_conf, result)
end

main if $PROGRAM_NAME == __FILE__
