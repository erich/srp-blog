# download csv
# parse csv
# save to active record
require 'net/http'
require 'active_record'
require 'csv'
require 'pry'

class DownloadAndSaveCSV
  attr_reader :url

  def initialize(url)
    @url = URI(url)
  end

  def call
    csv_data = Net::HTTP.get(url)
    ParseAndStoreCSV.new(csv_data).call
  end
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database  => 'database.sqlite'
)

class Item < ActiveRecord::Base
end

class ParseAndStoreCSV
  attr_reader :csv

  def initialize(csv)
    @csv = csv
  end

  def call
    begin
      options = { col_sep: ",", quote_char:'"' }
      CSV.parse(csv, options) do |row|
        Item.create(name: row.first)
      end
    rescue NoMethodError => e
      # notify airbrake
    end
  end

end
