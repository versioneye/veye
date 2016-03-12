require 'test_helper'
require 'csv'

class PackageReferenceTest < MiniTest::Test
  def setup
    init_environment
    @api_key = ENV["VEYE_API_KEY"]
  end

  def test_reference_with_results
    VCR.use_cassette('package_reference') do
      output = capture_stdout do
        Veye::Package::References.get_references(@api_key, 'ruby/ruby', {})
      end
      refute_nil output, "Command output was nil"
      rows = output.split(/\n/)
      assert_equal "  1 - \e[32mgitit\e[0m", rows[0]
      assert_equal "\tProduct key    : \e[1mgitit\e[0m", rows[1]
      assert_equal "\tProduct type   : RubyGem", rows[2]
      assert_equal "\tLanguage       : ruby", rows[3]
      assert_equal "\tVersion        : \e[32m2.0.2\e[0m", rows[4]
    end
  end

  def test_reference_csv_format
    VCR.use_cassette('package_reference') do
      output = capture_stdout do
        Veye::Package::References.get_references(@api_key, 'ruby/ruby', {format: 'csv'})
      end
      refute_nil output, "Command output was nil"
      rows = CSV.parse(output)
      assert_equal ["nr", "name", "language", "prod_key", "prod_type", "version"], rows[0]
      assert_equal ["1", "gitit", "ruby", "gitit", "RubyGem", "2.0.2"], rows[1]
    end
  end

  def test_reference_json_format
    VCR.use_cassette('package_reference') do
      output = capture_stdout do
        Veye::Package::References.get_references(@api_key, 'ruby/ruby', {format: 'json'})
      end
      refute_nil output, "Command output was nil"
      dt = JSON.parse(output)
      pkg = dt["results"].first
      assert_equal "gitit", pkg["name"]
      assert_equal "ruby", pkg["language"]
      assert_equal "gitit", pkg["prod_key"]
      assert_equal "2.0.2", pkg["version"]
      assert_equal "RubyGem", pkg["prod_type"]
    end
  end

  def test_reference_table_format
    VCR.use_cassette('package_reference') do
      output = capture_stdout do
        Veye::Package::References.get_references(@api_key, 'ruby/ruby', {format: 'table'})
      end
      refute_nil output, "Command output was nil"
      rows = output.split(/\n/)
      assert_match(/\|\s+Package references\s+\|/, rows[1])
      assert_match(
        /\| index \| name\s+\| version \| product_key\s+\| product_type \| language \|/,
        rows[3]
      )
      assert_match(
        /\| 1\s+\| gitit\s+\| 2.0.2\s+\| gitit\s+\| RubyGem\s+\| ruby\s+\|/,
        rows[5]
      )
    end
  end

end
