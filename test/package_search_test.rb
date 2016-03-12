require 'test_helper'
require 'csv'

class PackageSearchTest < MiniTest::Test
  def setup
    init_environment
  end

  def test_search_when_success
    VCR.use_cassette('package_search') do
      output = capture_stdout do
        Veye::Package::Search.search('veye', {})
      end
      refute_nil output, "Command output was nil"
      rows = output.split(/\n/)
      assert_equal "  1 - \e[32m\e[1mveye\e[0m", rows[0]
      assert_equal "\tProduct key    : veye", rows[1]
      assert_equal "\tLatest version : \e[32m\e[1m0.0.9\e[0m", rows[2]
      assert_equal "\tLanguage       : ruby", rows[3]
    end
  end

  def test_search_csv_format
    VCR.use_cassette('package_search') do
      output = capture_stdout do
        Veye::Package::Search.search('veye', {format: "csv"})
      end
      refute_nil output, "Command output was nil"

      rows = CSV.parse(output)
      assert_equal ["nr", "name", "version", "prod_key", "language", "group_id"], rows[0]
      assert_equal ["1", "veye", "0.0.9", "veye", "ruby", nil], rows[1]
    end
  end

  def test_search_json_format
    VCR.use_cassette('package_search') do
      output = capture_stdout do
        Veye::Package::Search.search('veye', {format: "json"})
      end
      refute_nil output, "Command output was nil"

      dt = JSON.parse(output)
      res = dt["results"].first
      assert_equal "veye", res["name"]
      assert_equal "ruby", res["language"]
      assert_equal "veye", res["prod_key"]
      assert_equal "0.0.9", res["version"]
      assert_equal "RubyGem", res["prod_type"]
    end
  end

  def test_search_table_format
    VCR.use_cassette('package_search') do
      output = capture_stdout do
        Veye::Package::Search.search('veye', {format: "table"})
      end
      refute_nil output, "Command output was nil"

      rows = output.split(/\n/)
      assert_match(/\|\s+Package search\s+\|/, rows[1])
      assert_match(/\| index \| name \| version \| product_key \| language \|/, rows[3])
      assert_match(/\| 1\s+\| veye \| 0.0.9\s+\| veye\s+\| ruby\s+\|/, rows[5])
    end
  end
end
