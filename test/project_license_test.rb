require 'test_helper'
require 'csv'

class ProjectLicenseTest < MiniTest::Test
  def setup
    init_environment
    @api_key    = ENV["VEYE_API_KEY"]
    @test_file  = 'test/files/maven-1.0.1.pom.xml'
    @org_name   = 'veye_test'
    @project_key = upload_project['id']
  end

  def teardown
    VCR.use_cassette('project_delete_for_licenses') do
      Veye::Project::Check.delete_project(@api_key, @project_key)
    end
  end

  def upload_project
    VCR.use_cassette('project_upload_for_licenses') do
      res = Veye::API::Project.upload(@api_key, @test_file, @org_name, nil, false)
      refute_nil 'Failed to create a project for licenses spec'
      res.data
    end
  end

  def test_get_licenses_default
    VCR.use_cassette("project_license_command") do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@api_key, @project_key, {})
      end

      rows = output.split(/\n/)
      assert_equal("  1 - \e[32m\e[1mApache-2.0\e[0m", rows[0])
      assert_match(/\tProducts\s+:\s+org\.apache\.maven\.plugin-tools\/maven-plugin-annotations/, rows[1])
    end
  end

  def test_get_licenses_json
    VCR.use_cassette('project_license_command') do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@api_key, @project_key, {format: "json"})
      end

      res = JSON.parse(output)
      assert_equal(false, res["licenses"].has_key?("unknown") )
    end
  end

  def test_get_licenses_csv
    VCR.use_cassette('project_license_command') do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@api_key, @project_key, {format: "csv"})
      end

      rows = CSV.parse(output)
      assert_equal(["nr", "license", "product_keys"], rows[0])
      assert_equal(
        ["1", "Apache-2.0", "org.apache.maven.plugin-tools/maven-plugin-annotations", "org.codehaus.plexus/plexus-utils"], 
        rows[1][0,4]
      )
    end
  end


  def test_get_licenses_table
    VCR.use_cassette('project_license_command') do
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

