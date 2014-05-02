require 'rest-client'
require 'xmlsimple'

class SpreadsheetData
  SPREADSHEET_URL = "https://spreadsheets.google.com/feeds/cells/#{ENV['main_spreadsheet_key']}"

  def self.content(worksheet, row, column)
    begin
      response = RestClient.get("#{SPREADSHEET_URL}/#{worksheet}/public/values/R#{row}C#{column}")
      parsed = XmlSimple.xml_in(response)['content']['content']
      sleep(2)
    end until parsed != '#N/A' && parsed != '#VALUE!'
    parsed
  end
end
