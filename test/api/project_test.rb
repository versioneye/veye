require 'test_helper'

class ProjectTest < Minitest::Test
  def setup
    init_environment
    @api_key      = ENV["VEYE_API_KEY"]
    @test_file    = "test/files/maven-1.0.1.pom.xml"
    @test_file2   = "test/files/Gemfile"
    @project_key  = upload_project["id"]

    @org_name     = "veye_test"
    @team_name    = "veye_cli_tool"
  end

  def upload_project(test_file = nil, is_temporary = true, task_id = nil)
    cassette_name = ( task_id.nil? ? 'project_upload' : "project_upload_#{task_id}" ) 
    test_file ||= @test_file
    org_name = @org_name
      
    VCR.use_cassette(cassette_name) do
      res = Veye::API::Project.upload(@api_key, test_file, org_name, nil, is_temporary)
      res.data
    end
  end

  def delete_project(project_id, task_id = nil)
    VCR.use_cassette("project_delete_#{task_id.to_s}") do
      res = Veye::API::Project.delete_project(@api_key, project_id)
      res.data
    end
  end

  def test_get_list_api_call
    VCR.use_cassette('project_list') do
      res = Veye::API::Project.get_list(@api_key, @org_name)

      assert_equal 200, res.code
      assert_equal true, res.success

      proj = res.data.first
      assert_equal "OpenEJB :: Maven Plugins", proj["name"]
      assert_equal "Maven2", proj["project_type"]
      assert_equal false, proj["public"]
      assert_equal "API", proj["source"]
    end
  end

  def test_check_file
    assert_match(
      /.*veye\/test\/files\/maven-1\.0\.1\.pom\.xml$/,
      Veye::API::Project.check_file(@test_file)
    )

    assert_nil(Veye::API::Project.check_file("files/nO_such_file.exe"))
  end

  def test_upload_api_call_when_file_doesnt_exists
    assert_nil Veye::API::Project.upload(@api_key, "files/nofile.erb")
  end

  def test_upload_api_call_when_file_exists
    VCR.use_cassette('project_upload') do
      res = Veye::API::Project.upload(@api_key, @test_file, @org_name)
      refute_nil res
      assert_equal 201, res.code
      assert_equal true, res.success
      assert_equal @project_key, res.data['id']
      assert_equal "OpenEJB :: Maven Plugins", res.data["name"]
      assert_equal "Maven2", res.data["project_type"]
      assert_equal true, res.data["public"]
      assert_equal "API", res.data["source"]
    end
  end

  def test_upload_attaches_optional_arguments
    VCR.use_cassette('project_upload_with_args') do
      res = Veye::API::Project.upload(@api_key, @test_file, @org_name, @team_name, true, false, 'nipitiri')
      refute_nil res

      assert_equal 201, res.code
      assert_equal true, res.success
      assert_equal 'nipitiri', res.data['name']
      assert_equal false, res.data['public']
    end
  end

  
  def test_update_api_call
    proj_dt = {}
    VCR.use_cassette('project_upload_for_update') do
      res = Veye::API::Project.upload(@api_key, @test_file, @org_name, @team_name, false)
      refute_nil res
      proj_dt = res.data
    end

    VCR.use_cassette('project_update') do
      res = Veye::API::Project.update(@api_key, proj_dt['id'], @test_file)
      refute_nil res
      assert_equal 201, res.code
      assert_equal true, res.success
      proj = res.data
      assert_equal proj_dt['id'], proj["id"]
      assert_equal "OpenEJB :: Maven Plugins", proj["name"]
      assert_equal "Maven2", proj["project_type"]
      assert_equal true, proj["public"]
      assert_equal "API", proj["source"]
      assert_equal 11, proj["dependencies"].count
    end

    VCR.use_cassette('project_delete_for_update') do
      Veye::API::Project.delete_project(@api_key, proj_dt['id'])
    end
  end

  def test_get_project_api_call
    VCR.use_cassette("project_get") do
      res = Veye::API::Project.get_project(@api_key, @project_key)
      refute_nil res
      assert_equal true, res.success
      assert_equal 200, res.code

      proj = res.data
      assert_equal @project_key, proj["id"]
      assert_equal "OpenEJB :: Maven Plugins", proj["name"]
      assert_equal "Maven2", proj["project_type"]
      assert_equal true, proj["public"]
      assert_equal "API", proj["source"]
      assert_equal 11, proj["dependencies"].count
    end
  end

  def test_delete_project_api_call
    VCR.use_cassette("project_delete") do
      res = Veye::API::Project.delete_project(@api_key, @project_key)
      refute_nil res
      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal(
        {"success"=>true, "message"=>"Project deleted successfully."},
        res.data
      )
    end
  end

  def test_get_licenses_api_call
    VCR.use_cassette('project_license') do
      res = Veye::API::Project.get_licenses(@api_key, @project_key)
      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal true, res.data["success"]

      licenses = res.data["licenses"]
      apache_license = licenses["Apache-2.0"].first
      assert_equal({
        "name" => "maven-plugin-annotations",
        "prod_key" => "org.apache.maven.plugin-tools/maven-plugin-annotations"
      }, apache_license)
    end
  end

  def test_merge_api_call
    #upload 2projects
    parent_id = upload_project(@test_file, false, 'merge_parent')['id']
    child_id  = upload_project(@test_file2, false, 'merge_child')['id']
    
    VCR.use_cassette('project_merge') do
      res = Veye::API::Project.merge(@api_key, parent_id, child_id)
      assert_equal true, res.success
      assert_equal true, res.data['success']
    end

    VCR.use_cassette('project_unmerge') do
      res = Veye::API::Project.unmerge(@api_key, parent_id, child_id)
      assert_equal true, res.success
      assert_equal true, res.data['success']
    end
    #delete projects
    delete_project(parent_id, 'merge_parent')
    delete_project(child_id, 'merge_child')
  end

end
