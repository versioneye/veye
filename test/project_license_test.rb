require 'test_helper'
require 'csv'

class ProjectLicenseTest < MiniTest::Test
  def setup
    init_environment
    @api_key = ENV["VEYE_API_KEY"]
    @test_file = 'test/files/maven-1.0.1.pom.xml'

    project_dt = upload_project(@api_key, @test_file)
    @project_key = project_dt['id']
  end

  def upload_project(api_key, test_file)
    VCR.use_cassette('project_upload') do
      output = capture_stdout do
        Veye::Project::Check.upload(api_key, test_file, {format: 'json'})
      end

      res = JSON.parse(output)
      res["projects"]
    end
  end

  def test_get_licenses_default
    VCR.use_cassette("project_license") do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@api_key, @project_key, {})
      end

      rows = output.split(/\n/)
      assert_equal("  1 - \e[32m\e[1mApache-2.0\e[0m", rows[0])
      assert_match(/\tProducts\s+:\s+org\.apache\.maven\.plugin-tools\/maven-plugin-annotations/, rows[1])
    end
  end

  def test_get_licenses_json
    VCR.use_cassette('project_license') do
      output = capture_stdout do |x|
        Veye::Project::License.get_licenses(@api_key, @project_key, {format: "json"})
      end

      res = JSON.parse(output)
      assert_equal(false, res["licenses"].has_key?("unknown") )
    end
  end

  def test_get_licenses_csv
    VCR.use_cassette('project_license') do
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

