require 'minitest/autorun'
require 'webmock/minitest'
require 'pry'
require_relative './download_and_save_csv'

class TestDownloadAndSaveCSV < Minitest::Test

  def setup
    Item.delete_all
    @download_and_save_csv = DownloadAndSaveCSV.new('http://example.com/list_of_items.csv')
  end

  def test_that_it_can_download_and_save_csv
    csv_response = CSV.generate do |csv|
      csv << ['John Lennon']
      csv << ['Ring Starr']
    end
    stub_request(:get, 'http://example.com/list_of_items.csv').
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'example.com', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => csv_response, :headers => {})
    @download_and_save_csv.call
    assert_equal 'John Lennon', Item.first.name
  end


  def test_that_it_handles_response_from_server_that_is_not_ok
    malformatted_response = "Mar 1, 2013 12:03:54 AM PST","5481545091"
    stub_request(:get, 'http://example.com/list_of_items.csv').
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'example.com', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => malformatted_response, :headers => {})
    @download_and_save_csv.call
    assert_equal 0, Item.count
  end
end
