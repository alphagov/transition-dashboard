require 'rest-client'
require 'xmlsimple'

class SpreadsheetData
  SPREADSHEET_URL = "https://spreadsheets.google.com/feeds/cells/#{ENV['main_spreadsheet_key']}"

  def self.content(worksheet, row, column)
    begin
      response = RestClient.get("#{SPREADSHEET_URL}/#{worksheet}/public/values/R#{row}C#{column}")
      parsed = XmlSimple.xml_in(response)['content']['content']
      if parsed.include?('/')
        # Assume it is a date of the form mm/dd/yyyy, rearrange it to
        # yyyymmdd and treat it like a time.
        parsed_split = parsed.split('/')
        parsed = Date.new(parsed_split[2].to_i,
                          parsed_split[0].to_i,
                          parsed_split[1].to_i
                         ).to_time
      end
      sleep(2)
    end until parsed != '#N/A' && parsed != '#VALUE!'
    parsed
  end
end
