require 'rest_client'
require 'xmlsimple'
require 'titleize'

org_top_ten = Hash.new({ value: 0 })

def get_organisation_transition_spreadsheet_data(row, column)
  # Worksheet three for the list of top 10 agencies.
  spreadsheet_url = "https://spreadsheets.google.com/feeds/cells/#{ENV['main_spreadsheet_key']}/3/public/values"

  data = Array.new
  (0..4).each do |i|
    response = RestClient.get("#{spreadsheet_url}/R#{row}C#{column}")
    data[i] = XmlSimple.xml_in(response)['content']['content']
    column += 1
  end
  data
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
    org_data = get_organisation_transition_spreadsheet_data(row, 1)

    org_top_ten[org_number] = {
                                label: org_data[0],
                                status: abbreviate_status(org_data[1]),
                                target: org_data[2].strip.split("-")[0],
                                rag: org_data[3]
                              }
    row += 1
    org_number += 1
  end

  send_event('org_top_ten', { items: org_top_ten.values })
end
