# download csv
# parse csv
# save to active record
require 'net/http'
require 'active_record'
require 'csv'

class DownloadAndSaveCSV
  attr_reader :url

  def initialize(url)
    @url = URI(url)
  end

  def call
    csv_data = Net::HTTP.get(url)
    CSV.parse(csv_data) do |row|
      Item.create(name: row.first)
    end
  end
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database  => 'database.sqlite'
)

class Item < ActiveRecord::Base
end
