require 'test_helper'
require 'csv'

class PackageInfoTest < Minitest::Test
  def setup
    init_environment
    @api_key = ENV['VEYE_API_KEY']
  end

  def test_info_default
    VCR.use_cassette('package_info_default') do
      output = capture_stdout do
        Veye::Package::Info.get_package(@api_key, 'veye', 'ruby')
      end
      refute_nil output, "No command output"

      rows = output.split(/\n/)
      assert_match(/\t\e\[32m\e\[1mveye\e\[0m/ , rows[0])
      assert_equal "\tLanguage       : ruby", rows[1]
      assert_equal "\tLicense        : MIT", rows[2]
      assert_equal "\tProduct type   : RubyGem", rows[3]
      assert_equal "\tProduct key    : \e[1mveye\e[0m", rows[4]
    end
  end

  def test_info_csv_format
    VCR.use_cassette('package_info_versioned') do
      output = capture_stdout do
        Veye::Package::Info.get_package(@api_key, 'veye', 'ruby', '0.2.1', {format: 'csv'})
      end
      refute_nil output, "No command output"
      
      rows = CSV.parse(output)
      assert_equal ["name", "version", "language", "prod_key", "licence", "prod_type", "description", "link", 'cves'], rows[0]
      assert_equal ["veye", "0.2.1", "ruby", "veye", nil, "RubyGem"], rows[1].take(6)
    end
  end

  def test_info_json_format
    VCR.use_cassette('package_info_versioned') do
      output = capture_stdout do
        Veye::Package::Info.get_package(@api_key, 'veye', 'ruby', '0.2.1', {format: 'json'})
      end

      refute_nil output
      dt = JSON.parse(output)
      package = dt["package"]
      assert_equal "veye", package["name"]
      assert_equal "ruby", package["language"]
      assert_equal "veye", package["prod_key"]
      assert_match(/\d+\.\d+\.\d+/, package["version"])
      assert_equal "RubyGem", package["prod_type"]
      assert_equal "MIT", package["license_info"]

      dep = package["dependencies"].first
      assert_equal "awesome_print", dep["name"]
      assert_equal "~> 1.6", dep["version"]

      license = package["licenses"].first
      assert_equal "MIT", license["name"]
      assert_equal nil, license["url"]
    end
  end

  def test_info_table_format
    VCR.use_cassette('package_info_versioned') do
      output = capture_stdout do
        Veye::Package::Info.get_package(@api_key, 'veye', 'ruby', '0.2.1', {format: 'table'})
      end
      refute_nil output, "No command output"
      rows = output.split(/\n/)
      assert_match(/\|\s+Package information\s+\|/, rows[1])
      assert_match(/\| name \| version \| product_key \| language \| license \| description/, rows[3])
      assert_match(/\| veye \| 0.2.1   \| veye\s+\| ruby\s+| MIT\s+\|/, rows[5])
    end
  end
end
