require 'google_calendar'
require_relative 'config'

config = Config.new('config.toml').calendar_conf

# Create an instance of the calendar.
cal = Google::Calendar.new(client_id:      config[:client_id],
                           client_secret: config[:client_secret],
                           calendar: config[:calendar_id],
                           redirect_url: 'urn:ietf:wg:oauth:2.0:oob')

# A user needs to approve access in order to work with their calendars.
puts 'Visit the following web page in your browser and approve access.'
puts cal.authorize_url
puts "\nCopy the code that Google returned and paste it here:"

refresh_token = cal.login_with_auth_code($stdin.gets.chomp)

puts "your refresh token is:\n\t#{refresh_token}\n"
puts 'Press return to continue'
$stdin.gets.chomp
