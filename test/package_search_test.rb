require 'test_helper'

class PackageSearchTest < MiniTest::Test
  def setup
    init_environment
  end

  def test_search_api_call
    VCR.use_cassette('package_search') do
      res = Veye::Package::API.search('veye', {})
      refute_nil res
      assert_equal true, res.success
      assert_equal 200, res.code
      assert_equal [{"name" => "veye", "language" => "ruby", "prod_key" => "veye",
                     "version" => "0.0.8.1", "prod_type" => "RubyGem" }],
                   res.data["results"]
    end
  end

  def test_search_when_success
    VCR.use_cassette('package_search') do
      output = capture_stdout do
        Veye::Package::Search.search('veye', {})
      end

      expected = "  1 - \e[32m\e[1mveye\e[0m\n\tProduct key    : veye\n\tLatest version : \e[32m\e[1m0.0.8.1\e[0m\n\tLanguage       : ruby\n"
      assert_equal expected, output
    end
  end

  def test_search_csv_format
    VCR.use_cassette('package_search') do
      output = capture_stdout {|| Veye::Package::Search.search('veye', {format: "csv"})}
      expected = "nr,name,version,prod_key,language,group_id\n1,veye,0.0.8.1,veye,ruby,\n"
      assert_equal expected, output
    end
  end

  def test_search_json_format
    VCR.use_cassette('package_search') do
      output = capture_stdout {|| Veye::Package::Search.search('veye', {format: "json"})}
      expected = "{\"results\":[{\"name\":\"veye\",\"language\":\"ruby\",\
\"prod_key\":\"veye\",\"version\":\"0.0.8.1\",\"prod_type\":\"RubyGem\"}]}\n"
      assert_equal expected, output
    end
  end

  def test_search_table_format
    VCR.use_cassette('package_search') do
      output = capture_stdout {|| Veye::Package::Search.search('veye', {format: "table"})}
      expected = "\
+-------+------+---------+-------------+----------+\n\
|                 Package search                  |\n\
+-------+------+---------+-------------+----------+\n\
| index | name | version | product_key | language |\n\
+-------+------+---------+-------------+----------+\n\
| 1     | veye | 0.0.8.1 | veye        | ruby     |\n\
+-------+------+---------+-------------+----------+\n"
      assert_equal expected, output
    end
  end
end
