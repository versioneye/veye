require 'test_helper'
require 'csv'

class ProjectLicenseTest < MiniTest::Test
  def setup
    init_environment
    @project_key = '55dc6de68d9c4b00210007bf'
    @api_key = ENV["VEYE_API_KEY"]
  end

  def test_get_licenses_default
    VCR.use_cassette("project_license") do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@api_key, @project_key, {})
      end

      rows = output.split(/\n/)
      assert_equal("  1 - \e[32m\e[1mMIT\e[0m", rows[0])
      assert_match(/\tProducts\s+ : veye, awesome_print/, rows[1])
    end
  end

  def test_get_licenses_json
    VCR.use_cassette('project_license') do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@api_key, @project_key, {format: "json"})
      end

      res = JSON.parse(output)
      unknown_licenses = res["licenses"]["unknown"]
      assert_equal({"name" => "gli", "prod_key" => "gli"}, unknown_licenses[1])
    end
  end

  def test_get_licenses_csv
    VCR.use_cassette('project_license') do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@api_key, @project_key, {format: "csv"})
      end

      rows = CSV.parse(output)
      assert_equal(["nr", "license", "product_keys"], rows[0])
      assert_equal(["1", "MIT", "veye", "awesome_print"], rows[1][0,4])
    end
  end


  def test_get_licenses_table
    VCR.use_cassette('project_license') do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@api_key, @project_key, {format: "table"})
      end

      rows = output.split(/\n/)
      assert_match(/|\s+Licences\s+|/, rows[1])
      assert_match(/| index | license\s+| product_keys\s+|/, rows[3])
      assert_match(/| 1\s+| unknown\s+| gli\s+|/, rows[5])
    end
  end
end

