def graph_points(type)
  row = 2
  dates = []
  actual_training = []
  expected_training = []

  # There are twenty-eight rows in the spreadsheet.
  (0..27).each do
    # Format of method params: Worksheet, Row, Column.
    dates.push({ x: SpreadsheetData.content(2, row, 1) })
    actual_training.push({ y: SpreadsheetData.content(2, row, 2) })
    expected_training.push({ y: SpreadsheetData.content(2, row, 3) })
    row += 1
  end

  # Condense the two hashes into actual or expected arrays of hashes
  # of the form:
  # [{:x=>"1/26/2014", :y=>"800"}]
  if type == 'actual'
    return dates.zip(actual_training).collect { |array| array.inject(:merge) }
  elsif type == 'expected'
    return dates.zip(expected_training).collect { |array| array.inject(:merge) }
  end
end

SCHEDULER.every '2h', :first_in => 0 do |job|
  send_event('burndown_chart', { actual: graph_points('actual'),
                                 expected: graph_points('expected') })
end
