require 'minitest/autorun'
require 'webmock/minitest'
require 'pry'
require_relative './download_and_save_csv'

class TestDownloadAndSaveCSV < Minitest::Test

  def setup
    Item.destroy_all
    @download_and_save_csv = DownloadAndSaveCSV.new('http://example.com/list_of_items.csv')
  end

  def test_that_it_can_download_and_save_csv
    csv_response = CSV.generate do |csv|
      csv << ['Name']
      csv << ['John Lennon']
      csv << ['Ring Starr']
    end
    stub_request(:get, 'http://example.com/list_of_items.csv').
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'example.com', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => csv_response, :headers => {})
    @download_and_save_csv.call
    assert Item.first.name, 'John Lennon'
  end


  def test_that_it_handles_response_from_server_that_is_not_csv
    string = 'string'
    stub_request(:get, 'http://example.com/list_of_items.csv').
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'example.com', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => string, :headers => {})
    @download_and_save_csv.call
    assert Item.first.name, 'John Lennon'
  end
end
