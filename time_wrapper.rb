# frozen_string_literal: true

require 'date'

def current_time
  today = Date.today
  month = Date::MONTHNAMES[today.month]
  final_structure = { year: today.year,
                      month: today.month,
                      month_literal: month }
  final_structure
end
