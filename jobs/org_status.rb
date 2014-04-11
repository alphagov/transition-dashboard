require 'rest_client'
require 'xmlsimple'

SPREADSHEET_ROOT = "https://spreadsheets.google.com/feeds/cells/#{ENV['main_spreadsheet_key']}/od6/public/values"

SCHEDULER.every '15m', :first_in => 0 do |job|
  begin
    done = XmlSimple.xml_in(RestClient.get("#{SPREADSHEET_ROOT}/R1C6"))['content']['content']
    todo = XmlSimple.xml_in(RestClient.get("#{SPREADSHEET_ROOT}/R1C8"))['content']['content']
    sleep(2)
  end until done != '#N/A' && done != '#VALUE!' && todo != "#N/A" && todo != '#VALUE!'

  send_event('orgs_done', { done: done })
  send_event('orgs_todo', { todo: todo })
end
