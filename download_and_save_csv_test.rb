require 'minitest/autorun'

class TestDownloadAndSaveCSV < Minitest::Test

  def setup
    @download_and_save_csv = DownloadAndSaveCSV.new(url: 'http://example.com/list_of_items.csv')
  end

  def test_that_it_can_download_and_save_csv
    @download_and_save_csv.call
    assert Item.first.name, 'John Lennon'
  end
end
