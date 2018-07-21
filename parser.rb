require 'httparty'
require 'nokogiri'
require 'date'

def row_get(html)
  table = Nokogiri::HTML(html).css('table')[1]
  field_of_interest = table.css('tbody').css('tr')
  field_of_interest
end

def data_generation(row, release_date)
  row_data = row.css('td')
  release_date = row_data[0].text unless row_data[0].text == ''
  # WHAT THE FUCK RUBY
  release_time = if row_data[1].text != '' || row_data[1].text != '?'
                   row_data[1].text
                 else
                   '00:00'
                 end
  artist_name = row_data[2].text
  album_title = row_data[3].text
  album_type = row_data[4].text
  title_track = row_data[5].text
  result = { release_date: release_date, release_time: release_time,
             artist_name: artist_name, album_title: album_title,
             album_type: album_type, title_track: title_track }
  result
end

def parse(response)
  final_array = []
  release_date = nil
  rows = row_get(response)
  rows.each do |row|
    row_result = data_generation(row, release_date)
    release_date = row_result[:release_date]
    final_array << row_result
  end
  final_array
end

def request(current_time)
  header = { 'User-Agent' => 'Mozilla' }
  reddit_url = 'https://www.reddit.com/r/kpop/wiki/upcoming-releases/'\
               "#{current_time[:year]}/#{current_time[:month]}"
  response = HTTParty.get(reddit_url, headers: header).body
  response
end

def current_time
  today = Date.today
  year = today.year
  month = Date::MONTHNAMES[today.month]
  final_structure = { year: year, month: month }
  final_structure # Ruby, what the fuck?
end
