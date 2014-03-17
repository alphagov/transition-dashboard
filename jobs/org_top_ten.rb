require 'rest_client'
require 'xmlsimple'

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
    # but in CamelCase to match with the above.
    status.camelize
  end
end

SCHEDULER.every '2h', :first_in => 0 do |job|
  first_org = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R2C1"))['content']['content']
  first_status = abbreviate_status(XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R2C2"))['content']['content'])
  org_top_ten[first_org] = { label: first_org, value: first_status }

  second_org = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R3C1"))['content']['content']
  second_status = abbreviate_status(XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R3C2"))['content']['content'])
  org_top_ten[second_org] = { label: second_org, value: second_status }

  third_org = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R4C1"))['content']['content']
  third_status = abbreviate_status(XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R4C2"))['content']['content'])
  org_top_ten[third_org] = { label: third_org, value: third_status }

  fourth_org = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R5C1"))['content']['content']
  fourth_status = abbreviate_status(XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R5C2"))['content']['content'])
  org_top_ten[fourth_org] = { label: fourth_org, value: fourth_status }

  fifth_org = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R6C1"))['content']['content']
  fifth_status = abbreviate_status(XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R6C2"))['content']['content'])
  org_top_ten[fifth_org] = { label: fifth_org, value: fifth_status }

  sixth_org = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R7C1"))['content']['content']
  sixth_status = abbreviate_status(XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R7C2"))['content']['content'])
  org_top_ten[sixth_org] = { label: sixth_org, value: sixth_status }

  seventh_org = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R8C1"))['content']['content']
  seventh_status = abbreviate_status(XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R8C2"))['content']['content'])
  org_top_ten[seventh_org] = { label: seventh_org, value: seventh_status }

  eighth_org = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R9C1"))['content']['content']
  eighth_status = abbreviate_status(XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R9C2"))['content']['content'])
  org_top_ten[eighth_org] = { label: eighth_org, value: eighth_status }

  ninth_org = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R10C1"))['content']['content']
  ninth_status = abbreviate_status(XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R10C2"))['content']['content'])
  org_top_ten[ninth_org] = { label: ninth_org, value: ninth_status }

  tenth_org = XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R11C1"))['content']['content']
  tenth_status = abbreviate_status(XmlSimple.xml_in(RestClient.get("#{spreadsheet_end_url}/R11C2"))['content']['content'])
  org_top_ten[tenth_org] = { label: tenth_org, value: tenth_status }

  send_event('org_top_ten', { items: org_top_ten.values })
end
