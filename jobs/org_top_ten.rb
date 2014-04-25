require 'titleize'

org_top_ten = Hash.new({ value: 0 })

def organisations
  organisations = []
  # Each row represents an organisation.
  # Worksheet, row, column.
  (2..11).each do |row|
    organisations << {
      label: SpreadsheetData.content(3, row, 1),
      status: abbreviate_status(SpreadsheetData.content(3, row, 2)),
      target: SpreadsheetData.content(3, row, 3).strip.split("-")[0],
      rag: SpreadsheetData.content(3, row, 4)
    }
  end
  organisations
end

def abbreviate_status(status)
  # Construct abbreviations for one long status from the spreadsheet.
  if status.downcase.strip == "content analysis, build & publish"
    "Content Build"
  else
    # Return the status as normal as it doesn't need abbreviating,
    # but in Title Case to match with the above.
    status.titleize
  end
end

SCHEDULER.every '2h', :first_in => 0 do |job|
  send_event('org_top_ten', { items: organisations })
end
