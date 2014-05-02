require 'rest_client'
require 'xmlsimple'

def graph_points
  graph_points = []
  worksheet = 2
  row = 2
  column = 1
  dates = []
  actual_numbers = []

  # There are twenty-eight rows in the spreadsheet.
  (0..27).each do
    dates.push(SpreadsheetData.content(worksheet, row, column))
    actual_numbers.push(SpreadsheetData.content(worksheet, row, (column += 1)))
    column = 1 # For each iteration of row, reset the column count.
    row += 1
  end

  dates.each do |date|
    graph_points << { x: date }
  end
  actual_numbers.each do |number|
    graph_points << { y: number }
  end
  puts graph_points.inspect
  graph_points
end

SCHEDULER.every '2h', :first_in => 0 do |job|
  send_event('burndown_chart', { points: graph_points })
end
