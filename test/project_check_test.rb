require 'test_helper'
require 'csv'

class ProjectCheckTest < Minitest::Test
  def setup
    init_environment
    @api_key = ENV['VEYE_API_KEY']
    @test_file = "test/files/maven-1.0.1.pom.xml"
   	@org_name  = 'veye_test'
    @team_name = 'veye_cli_tool'

    @project_key = upload_project["id"]
  end

  def upload_project
    VCR.use_cassette('project_upload') do
      res = Veye::API::Project.upload(@api_key, @test_file, @org_name, nil, true)
      res.data
    end
  end


  def test_get_list_default
    VCR.use_cassette('project_list') do
      output = capture_stdout do
        Veye::Project::Check.get_list(@api_key, @org_name, nil, {})
      end

      rows = output.split(/\n/)
      assert_equal "  1 - \e[32m\e[1mOpenEJB :: Maven Plugins\e[0m", rows[0]
      #assert_equal "\tProject key    : \e[1m#{@project_key}\e[0m", rows[1]
      assert_equal "\tProject type   : Maven2", rows[2]
      assert_equal "\tPublic         : false", rows[3]
      assert_equal "\tPeriod         : daily", rows[4]
      assert_equal "\tSource         : API", rows[5]
		  assert_equal "\tDependencies   : \e[1m11\e[0m", rows[6]
      assert_equal "\tOutdated       : \e[31m10\e[0m", rows[7]
    end
  end

  def test_get_list_csv
    VCR.use_cassette("project_list") do
      output = capture_stdout do
        Veye::Project::Check.get_list(@api_key, @org_name, nil, {format: 'csv'})
      end

      rows = CSV.parse(output)
      assert_equal ["nr", "name", "project_id", "public", "period", "source",
                    "dep_number", "out_number", "created_at"], rows[0]
      assert_equal ["1", "OpenEJB :: Maven Plugins", "57c05d11864739001066e3f1", "false",
                    "daily", "API", "11", "10"], rows[1].take(8)
    end
  end

  def test_get_list_json
    VCR.use_cassette("project_list") do
      output = capture_stdout do
        Veye::Project::Check.get_list(@api_key, @org_name, nil, {format: 'json'})
      end

      res = JSON.parse(output)
      projects = res["projects"]

      assert_equal("OpenEJB :: Maven Plugins", projects[0]["name"])
      assert_equal(false, projects[0]["public"])
      assert_equal("API", projects[0]["source"])
      assert_equal("daily", projects[0]["period"])
    end
  end

  def test_get_list_table
    VCR.use_cassette("project_list") do
      output = capture_stdout do
        Veye::Project::Check.get_list(@api_key, @org_name, nil, {format: 'table'})
      end

      rows = output.split(/\n/)
      assert_match(/\|\s+List of projects\s+\|/, rows[1])
      assert_match(
        /\| index\s+\| name\s+\| project_id\s+\|\s+public\s+\| period \| source \| dependencies \| outdated \| created_at\s+\|/,
        rows[3]
      )

      assert_match(/| 1\s+| bugtraqer\s+| lein_project_clj_1/, rows[5])
    end
  end


  def test_upload_default
    VCR.use_cassette('project_upload') do
      output = capture_stdout do
        Veye::Project::Check.upload(@api_key, @test_file, @org_name, @team_name, {format: 'pretty'})
      end

      refute_nil output
      rows = output.split(/\n/)
      assert_equal "  1 - \e[32m\e[1mOpenEJB :: Maven Plugins\e[0m", rows[0]
      assert_match( /\tProject id\s+:\s+/, rows[1] )
      assert_equal "\tProject type   : Maven2", rows[2]
      assert_equal "\tPublic         : true", rows[3]
      assert_equal "\tPeriod         : daily", rows[4]
      assert_equal "\tSource         : API", rows[5]
      assert_equal "\tDependencies   : \e[1m11\e[0m", rows[6]
      assert_equal "\tOutdated       : \e[31m10\e[0m", rows[7]
    end
  end

  def test_upload_csv
    VCR.use_cassette('project_upload') do
      output = capture_stdout do
        Veye::Project::Check.upload(@api_key, @test_file, @org_name, @team_name, {format: "csv"})
      end

      refute_nil output
      rows = CSV.parse(output)
      assert_equal ["nr", "name", "project_id", "public", "period", "source",
                    "dep_number", "out_number", "created_at"], rows[0]
      assert_equal ["1", "OpenEJB :: Maven Plugins", @project_key, "true"], rows[1].take(4)

    end
  end

  def test_upload_json
    VCR.use_cassette('project_upload') do
      output = capture_stdout do
        Veye::Project::Check.upload(@api_key, @test_file, @org_name, @team_name, {format: "json"})
      end

      refute_nil output
      res = JSON.parse(output)
      assert_equal "OpenEJB :: Maven Plugins", res["projects"]["name"]
      assert_equal "Maven2", res["projects"]["project_type"]
      assert_equal true, res["projects"]["public"]
      assert_equal "daily", res["projects"]["period"]
      assert_equal "API", res["projects"]["source"]
    end
  end

  def test_upload_table
    VCR.use_cassette('project_upload') do
      output = capture_stdout do
        Veye::Project::Check.upload(@api_key, @test_file, @org_name, @team_name, {format: "table"})
      end

      refute_nil output
      rows = output.split(/\n/)
      assert_match(/\|\s+List of projects\s+\|/, rows[1])
      assert_match(/\|\s+index\s+|\s+name\s+\|\s+project_id\s+\|\s+private\s+\|/, rows[3])
      assert_match(/\| 1\s+\|\s+OpenEJB :: Maven Plugins\s+\|/, rows[5])
    end
  end

  def upload_update_project
    proj_dt = {}
    VCR.use_cassette('project_upload_for_update') do
      res = Veye::API::Project.upload(@api_key, @test_file, @org_name, @team_name, false)
      refute_nil res, 'upload_update_project: failed to create a project for the update tests'
      proj_dt = res.data
    end

    proj_dt
  end

  def delete_update_project(proj_id)
    VCR.use_cassette('project_delete_for_update') do
      Veye::API::Project.delete_project(@api_key, proj_id)
    end
  end

  def test_update_default
    proj_dt = upload_update_project

    VCR.use_cassette('project_update') do
      output = capture_stdout do
        Veye::Project::Check.update(@api_key, proj_dt['id'], @test_file, {})
      end
      refute_nil output
      rows = output.split(/\n/)
      assert_equal "  1 - \e[32m\e[1mOpenEJB :: Maven Plugins\e[0m", rows[0]
      assert_equal "\tProject id     : \e[1m#{proj_dt['id']}\e[0m", rows[1]
      assert_equal "\tProject type   : Maven2", rows[2]
      assert_equal "\tPublic         : true", rows[3]
      assert_equal "\tPeriod         : daily", rows[4]
      assert_equal "\tSource         : API", rows[5]
      assert_equal "\tDependencies   : \e[1m11\e[0m", rows[6]
      assert_equal "\tOutdated       : \e[31m10\e[0m", rows[7]
    end
  
  ensure
    delete_update_project(proj_dt['id'])
  end

  def test_update_csv
    proj_dt = upload_update_project

    VCR.use_cassette('project_update') do
      output = capture_stdout do
        Veye::Project::Check.update(@api_key, proj_dt['id'], @test_file, {format: 'csv'})
      end

      refute_nil output
      rows = CSV.parse(output)
      assert_equal ["nr", "name", "project_id", "public", "period", "source",
                    "dep_number", "out_number", "created_at"], rows[0]
      assert_equal ["1", "OpenEJB :: Maven Plugins", proj_dt['id'], "true", "daily", "API", "11", "10"], rows[1].take(8)
    end

  ensure
    delete_update_project(proj_dt['id'])
  end

  def test_update_json
    proj_dt = upload_update_project

    VCR.use_cassette('project_update') do
      output = capture_stdout do
        Veye::Project::Check.update(@api_key, proj_dt['id'], @test_file, {format: 'json'})
      end

      refute_nil output
      res = JSON.parse(output)
      proj = res["projects"]
      assert_equal proj_dt['id'], proj['id']
      assert_equal "OpenEJB :: Maven Plugins", proj["name"]
      assert_equal "Maven2", 	proj["project_type"]
      assert_equal true, 		proj["public"]
      assert_equal "API", 		proj["source"]
      assert_equal 11, 				proj["dependencies"].count
    end
  ensure
    delete_update_project(proj_dt['id'])
  end

  def test_update_table
    proj_dt = upload_update_project

    VCR.use_cassette('project_update') do
      output = capture_stdout do
        Veye::Project::Check.update(@api_key, proj_dt['id'], @test_file, {format: 'table'})
      end

      refute_nil output
      rows = output.split(/\n/)

      assert_match(
        /| index \| name\s+\| project_id\s+\| private \| period \| source \|/, rows[4]
      )
      assert_match(/\| 1\s+\|\s+OpenEJB :: Maven Plugins\s+\|/, rows[5])

      assert_match(
      /\| index \| name\s+\| prod_key\s+\| version_current \| version_requested\s+\| outdated | stable/,
        rows[10]
      )

      #assert_match(/\| 1\s+\|\s+maven-plugin-annotations\s+\|/, rows[12])
    end
  ensure
    delete_update_project(proj_dt['id'])
  end

  def test_get_project_default
    VCR.use_cassette("project_get") do
      output = capture_stdout do
        Veye::Project::Check.get_project(@api_key, @project_key, {})
      end

      refute_nil output
      rows = output.split(/\n/)
      assert_equal "  1 - \e[32m\e[1mOpenEJB :: Maven Plugins\e[0m", rows[0]
      assert_equal "\tProject id     : \e[1m#{@project_key}\e[0m", rows[1]
      assert_equal "\tProject type   : Maven2", rows[2]
      assert_equal "\tPublic         : true", rows[3]
      assert_equal "\tPeriod         : daily", rows[4]
      assert_equal "\tSource         : API", rows[5]
      assert_equal "\tDependencies   : \e[1m11\e[0m", rows[6]
      assert_equal "\tOutdated       : \e[31m10\e[0m", rows[7]
    end
  end

  def test_get_project_csv
    VCR.use_cassette("project_get") do
      output = capture_stdout do
        Veye::Project::Check.get_project(@api_key, @project_key, {format: 'csv'})
      end

      refute_nil output
      rows = CSV.parse(output)
      assert_equal ["nr", "name", "project_id", "public", "period", "source", "dep_number", "out_number", "created_at"], rows[0]
      assert_equal ["1", "OpenEJB :: Maven Plugins", @project_key, "true", "daily", "API", "11", "10"], rows[1].take(8)
    end
  end

  def test_get_project_json
    VCR.use_cassette("project_get") do
      output = capture_stdout do
        Veye::Project::Check.get_project(@api_key, @project_key, {format: 'json'})
      end

      refute_nil output, "test_get_project_json output cant be empty"
      doc = JSON.parse(output)
      proj = doc["projects"]
      assert_equal true, 	proj["public"]
      assert_equal "API", 	proj["source"]
      assert_equal "daily", proj["period"]
      assert_equal 11, 			proj["dependencies"].count
    end
  end

  def test_get_project_table
    VCR.use_cassette("project_get") do
      output = capture_stdout do
        Veye::Project::Check.get_project(@api_key, @project_key, {format: 'table'})
      end

      refute_nil output

      rows = output.split(/\n/)
      assert_match(
        /| index \| name\s+\| project_id\s\| private \| period \| source \|/, rows[4]
      )
      assert_match(/\| 1\s+\| OpenEJB :: Maven Plugins\s+\|/, rows[5])

      assert_match(
      /\| index \| name\s+\| prod_key\s+\| version_current \| version_requested\s+\| outdated | stable/, rows[10]
      )
    end
  end

  def test_delete_project_default
    VCR.use_cassette("project_delete") do
      output = capture_stdout do
        Veye::Project::Check.delete_project(@api_key, @project_key)
      end

      refute_nil output
      assert_equal "\e[32mDeleted\n\e[0m", output
    end
  end

  def delete_file(file_path)
    abs_path = File.absolute_path(file_path)
    begin
      File.delete(File.absolute_path(abs_path))
    rescue
      p "failed to delete file #{abs_path}"
    end
  end
  #checking a files when project ids dont exists yet
  def test_check_default
    test_path = "test/files"
    settings_file = 'test/files/veye.json'

    delete_file(settings_file)

    VCR.use_cassette("project_check_new") do
      output = capture_stdout do
        Veye::Project::Check.check(
          @api_key, test_path, ['Gemfile', 'maven-1.0.1.pom.xml'], {}
        )
      end
      
      refute_nil output, "output of project_check_new cant be empty "
      rows = output.split(/\n/)

			assert_equal "project ids are saved into `\e[33mveye.json\e[0m`", rows[1]
			assert_equal "  1 - \e[32m\e[1msass-rails\e[0m", rows[3]
			assert_equal "\tSourcefile     : Gemfile", rows[4]
    end

    Veye::Settings.load(settings_file)
    VCR.use_cassette("project_check_update") do
      output = capture_stdout do
        Veye::Project::Check.check(
          @api_key, test_path, ['Gemfile', 'maven-1.0.1.pom.xml'], {}
        )
      end

      refute_nil output, "output of project_check_update cant be empty"
      rows = output.split(/\n/)
			assert_equal "project ids are saved into `\e[33mveye.json\e[0m`", rows[1]
			assert_equal "  1 - \e[32m\e[1msass-rails\e[0m", rows[3]
			assert_equal "\tSourcefile     : Gemfile", rows[4]

    end

    delete_file(settings_file)
  end
end
