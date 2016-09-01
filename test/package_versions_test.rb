require 'test_helper'
require 'csv'
require 'json'

class PackageVersionsTest < Minitest::Test
  def setup
    init_environment
    @api_key = ENV['VEYE_API_KEY']
  end

  def test_versions_default
    VCR.use_cassette('package_versions') do
      output = capture_stdout do
        Veye::Package::Versions.get_list(@api_key, 'ruby', 'ruby', 10, 0, {})
      end
      refute_nil output, 'No response from the API'

      rows = output.split(/\n/)
      assert_equal "\t\e[32m\e[1mruby\e[0m - \e[1m0.1.0\e[0m", rows[0]
      assert_equal "\tLanguage       : ruby", rows[1]
      assert_equal "\tProduct type   : RubyGem", rows[2]
      assert_equal "\tProduct key    : ruby", rows[3]
      assert_equal "\tShowing items  : 10 after skipping 0 items", rows[4]
      assert_equal "\t0.1.0          : 1\t2011-02-28T10:00:00.000+00:00", rows[5]
    end
  end

  def test_versions_csv_format
    VCR.use_cassette('package_versions') do
      output = capture_stdout do
        Veye::Package::Versions.get_list(@api_key, 'ruby', 'ruby', 10, 0, {format: 'csv'})
      end
      refute_nil output, "No API response"

      rows = CSV.parse(output)
      assert_equal ['nr', 'version', 'language', 'prod_key', 'prod_type', 'released_at'], rows[0]
      assert_equal ['1', '0.1.0', 'ruby', 'ruby', 'RubyGem', '2011-02-28T10:00:00.000+00:00'], rows[1]
    end
  end

  def test_versions_json_format
    VCR.use_cassette('package_versions') do
      output = capture_stdout do
        Veye::Package::Versions.get_list(@api_key, 'ruby', 'ruby', 10, 0, {format: 'json'})
      end
      refute_nil output, 'No API response'
      
      dt = JSON.parse output
      assert_equal 'ruby', dt['results']['prod_key']
      assert_equal 'ruby', dt['results']['language']
      assert_equal '0.1.0', dt['results']['versions'].first['version']
      assert_equal 10, dt['pagination']['n']
      assert_equal 0, dt['pagination']['from']
    end

  end
  
  def test_version_table_format
    VCR.use_cassette('package_versions') do
      output = capture_stdout do
        Veye::Package::Versions.get_list(@api_key, 'ruby', 'ruby', 10, 0, {format: 'table'})
      end
      refute_nil output, 'No API response'

      rows = output.split(/\n/)

      assert_match(/package versions/i, rows[1])
      assert_match(/| nr | name | version | released_at\s+|\s+product_key/i, rows[3])
      assert_match(/| 1  | ruby | 0.1.0   | 2011-02-28T10:00:00.000+00:00 | ruby/i, rows[5])
    end
  end

end
