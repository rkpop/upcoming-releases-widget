require_relative 'parser'

def main
  time = current_time
  response = request(time)
  result = parse(response)
  puts result
end

main if $PROGRAM_NAME == __FILE__
