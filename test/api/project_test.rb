require 'test_helper'

class ProjectTest < Minitest::Test
  def setup
    init_environment
    @api_key = 'ba7d93beb5de7820764e'
    @test_file = "test/files/maven-1.0.1.pom.xml"
    @project_key = "maven2_openejb_maven_plugins_1"
  end

  def test_get_list_api_call
    VCR.use_cassette('project_list') do
      res = Veye::API::Project.get_list(@api_key)

      assert_equal 200, res.code
      assert_equal true, res.success

      proj = res.data.first
      assert_equal "bugtraqer", proj["name"]
      assert_equal "lein_project_clj_1", proj["project_key"]
      assert_equal "Lein", proj["project_type"]
      assert_equal false, proj["public"]
      assert_equal "upload", proj["source"]
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
      res = Veye::API::Project.upload(@api_key, @test_file)
      refute_nil res
      assert_equal 201, res.code
      assert_equal true, res.success
      assert_equal "maven2_openejb_maven_plugins_1", res.data["project_key"]
      assert_equal "OpenEJB :: Maven Plugins", res.data["name"]
      assert_equal "Maven2", res.data["project_type"]
      assert_equal true, res.data["public"]
      assert_equal "API", res.data["source"]
    end
  end

  def test_update_api_call
    VCR.use_cassette('project_update') do
      res = Veye::API::Project.update(@api_key, @project_key, @test_file)
      refute_nil res
      assert_equal 201, res.code
      assert_equal true, res.success
      proj = res.data
      assert_equal @project_key, proj["project_key"]
      assert_equal "OpenEJB :: Maven Plugins", proj["name"]
      assert_equal "Maven2", proj["project_type"]
      assert_equal true, proj["public"]
      assert_equal "API", proj["source"]
      assert_equal 11, proj["dependencies"].count
    end
  end

  def test_get_project_api_call
    VCR.use_cassette("project_get") do
      res = Veye::API::Project.get_project(@api_key, @project_key)
      refute_nil res
      assert_equal true, res.success
      assert_equal 200, res.code

      proj = res.data
      assert_equal @project_key, proj["project_key"]
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
      res = Veye::API::Project.get_licenses(@api_key, 'rubygem_gemfile_lock_1')
      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal true, res.data["success"]

      licenses = res.data["licenses"]
      unknown_license = licenses["unknown"].first
      assert_equal({"name" => "gli" , "prod_key" => "gli" }, unknown_license)

      ruby_license = licenses["Ruby"].first
      assert_equal({ "name" => "json" , "prod_key" => "json"}, ruby_license)
    end
  end



end
