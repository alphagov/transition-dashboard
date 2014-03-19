require 'rest_client'
require 'xmlsimple'
require 'titleize'

spreadsheet_root = "https://spreadsheets.google.com/feeds/cells/#{ENV['main_spreadsheet_key']}"
# Worksheet three for the list of top 10 agencies.
spreadsheet_end_url = "#{spreadsheet_root}/3/public/values"

org_top_ten = Hash.new({ value: 0 })

def abbreviate_status(status)
  # Construct abbreviations for long statuses from the spreadsheet.
  if status.downcase.strip == "business as usual"
    "BAU"
  elsif status.downcase.strip == "content analysis, build & publish"
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
  (0..9).each do |orgs|
    org = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R#{row}C1"))['content']['content']
    status = abbreviate_status(XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R#{row}C2"))['content']['content'])
    target = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R#{row}C3"))['content']['content']
    rag = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R#{row}C4"))['content']['content']
    org_top_ten[org_number] = { label: org, rag: rag, status: status, target: target }
    row += 1
    org_number += 1
  end

  send_event('org_top_ten', { items: org_top_ten.values })
end
