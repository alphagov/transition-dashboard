SCHEDULER.every '15m', :first_in => 0 do |job|
  # Worksheet, row, column.
  worksheet = 'od6'
  send_event('orgs_done', { done: SpreadsheetData.content(worksheet, 1, 6) })
  send_event('orgs_todo', { todo: SpreadsheetData.content(worksheet, 1, 8) })
end
