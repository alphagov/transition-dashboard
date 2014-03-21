require 'rest_client'
require 'xmlsimple'
require 'titleize'

org_top_ten = Hash.new({ value: 0 })

def get_spreadsheet_xml(row, column)
  # Worksheet three for the list of top 10 agencies.
  spreadsheet_url = "https://spreadsheets.google.com/feeds/cells/#{ENV['main_spreadsheet_key']}/3/public/values"

  data = Hash.new()
  (0..4).each do |i|
    data[i] = XmlSimple.xml_in(RestClient.get("#{spreadsheet_url}/R#{row}C#{column}"))['content']['content']
    column += 1
  end
  data.values
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
  row = 2
  org_number = 0

  (0..9).each do
    org_values = get_spreadsheet_xml(row, 1)

    org_top_ten[org_number] = {
                                label: org_values[0],
                                status: abbreviate_status(org_values[1]),
                                target: org_values[2].strip.split("-")[0],
                                rag: org_values[3]
                              }
    row += 1
    org_number += 1
  end

  send_event('org_top_ten', { items: org_top_ten.values })
end
