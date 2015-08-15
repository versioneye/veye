require 'test_helper'
require 'csv'

class ProjectLicenseTest < MiniTest::Test
  def setup
    init_environment
    @project_key = 'rubygem_gemfile_lock_1'
    @api_key = 'ba7d93beb5de7820764e'
  end

  def test_get_licenses_default
    VCR.use_cassette("project_license") do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@project_key, @api_key, {})
      end

      rows = output.split(/\n/)
      assert_equal("  1 - \e[32m\e[1munknown\e[0m", rows[0])
      assert_equal("\tProducts        : gli", rows[1])
      assert_equal("  2 - \e[32m\e[1mMIT\e[0m", rows[2])
      assert_equal("\tProducts        : veye, awesome_print, rainbow, render-as-markdown, \
rest-client, terminal-table, aruba, childprocess, cucumber, rspec-expectations, builder, \
gherkin, multi_json, multi_test, rake", rows[3])
    end
  end

  def test_get_licenses_json
    VCR.use_cassette('project_license') do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@project_key, @api_key, {format: "json"})
      end

      res = JSON.parse(output)
      unknown_licenses = res["licenses"]["unknown"]
      assert_equal([{"name" => "gli", "prod_key" => "gli"}], unknown_licenses)
    end
  end

  def test_get_licenses_csv
    VCR.use_cassette('project_license') do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@project_key, @api_key, {format: "csv"})
      end

      rows = CSV.parse(output)
      assert_equal ["nr", "license", "product_keys"], rows[0]
      assert_equal ["1", "unknown", "gli"], rows[1]
      assert_equal ["2", "MIT", "veye", "awesome_print", "rainbow", "render-as-markdown",
                    "rest-client", "terminal-table", "aruba", "childprocess", "cucumber",
                    "rspec-expectations", "builder", "gherkin", "multi_json", "multi_test", "rake"],
                    rows[2]
    end
  end


  def test_get_licenses_table
    VCR.use_cassette('project_license') do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@project_key, @api_key, {format: "table"})
      end

      rows = output.split(/\n/)
      assert_equal "+-------+----------------------------+--------------------+", rows[0]
      assert_equal "|                        Licences                         |", rows[1]
      assert_equal "+-------+----------------------------+--------------------+", rows[2]
      assert_equal "| index | license                    | product_keys       |", rows[3]
      assert_equal "+-------+----------------------------+--------------------+", rows[4]
      assert_equal "| 1     | unknown                    | gli                |", rows[5]
    end
  end
end

