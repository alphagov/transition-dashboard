require 'rest_client'
require 'xmlsimple'

SPREADSHEET_ROOT = "https://spreadsheets.google.com/feeds/cells/#{ENV['main_spreadsheet_key']}/od6/public/values"

def fetch_with_retry(cell)
  begin
    value = XmlSimple.xml_in(RestClient.get("#{SPREADSHEET_ROOT}/#{cell}"))['content']['content']
    sleep(2)
  end until value != '#N/A' && done != '#VALUE!'
  value
end

SCHEDULER.every '15m', :first_in => 0 do |job|
  send_event('orgs_done', { done: fetch_with_retry('R1C6') })
  send_event('orgs_todo', { todo: fetch_with_retry('R1C8') })
end
