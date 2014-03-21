require 'rest_client'
require 'xmlsimple'
require 'titleize'

org_top_ten = Hash.new({ value: 0 })

# Worksheet three for the list of top 10 agencies.
SPREADSHEET_URL = "https://spreadsheets.google.com/feeds/cells/#{ENV['main_spreadsheet_key']}/3/public/values"

def cell_content(row, column)
  response = RestClient.get("#{SPREADSHEET_URL}/R#{row}C#{column}")
  XmlSimple.xml_in(response)['content']['content']
end

def organisations
  organisations = []
  # Each row represents an organisation.
  (2..11).each do |row|
    organisations << {
      label: cell_content(row, 1),
      status: abbreviate_status(cell_content(row, 2)),
      target: cell_content(row, 3).strip.split("-")[0],
      rag: cell_content(row, 4)
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
