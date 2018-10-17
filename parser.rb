# frozen_string_literal: true

require 'httparty'
require 'nokogiri'
require_relative 'time_wrapper'

def row_get(html)
  table = Nokogiri::HTML(html).css('table')[1]
  field_of_interest = table.css('tbody').css('tr')
  field_of_interest
end

def process_release_time(row_text, last_known_time)
  return last_known_time if row_text == ''
  return { hour: 18, minute: 0 } if row_text == '?'

  split = row_text.split(':')
  { hour: split.first.to_i, minute: split.last.to_i }
end

def process_release_date(row_text, last_known_date)
  return last_known_date if row_text == ''

  row_text[0..-3].to_i
end

def data_generation(row_data, release_date, release_time)
  release_date = process_release_date(row_data[0].text, release_date)
  release_time = process_release_time(row_data[1].text, release_time)
  result = { release_date: release_date, release_time: release_time,
             artist_name: row_data[2].text, album_title: row_data[3].text,
             album_type: row_data[4].text, title_track: row_data[5].text }
  result
end

def parse(response)
  final_array = []
  release_date = release_time = nil
  rows = row_get(response)
  rows.each do |row|
    row_result = data_generation(row.css('td'), release_date, release_time)
    release_date = row_result[:release_date]
    release_time = row_result[:release_time]
    final_array << row_result
  end
  final_array
end

def request(current_time)
  header = { 'User-Agent' => 'Mozilla' }
  reddit_url = 'https://www.reddit.com/r/kpop/wiki/upcoming-releases/'\
               "#{current_time[:year]}/#{current_time[:month_literal]}"
  response = HTTParty.get(reddit_url, headers: header).body
  response
end
