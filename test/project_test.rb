require 'test_helper'

class ProjectTest < Minitest::Test
  def setup
    init_environment
    @api_key = ENV['VEYE_API_KEY']
    @test_file    = "test/files/maven-1.0.1.pom.xml"
    @test_file2   = "test/files/Gemfile"

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

  def test_merge_and_unmerge_command
    #upload 2projects
    parent_id = upload_project(@test_file, false, 'merge_parent')['id']
    child_id  = upload_project(@test_file2, false, 'merge_child')['id']
    
    VCR.use_cassette('project_merge') do
      output = capture_stdout do
        Veye::Project.merge(@api_key, parent_id, child_id)
      end

      assert_equal "success: true\n", output
    end

    VCR.use_cassette('project_unmerge') do
      output = capture_stdout do
        Veye::Project.unmerge(@api_key, parent_id, child_id)
      end
  
      assert_equal "success: true\n", output
    end
    
    #delete projects
    delete_project(parent_id, 'merge_parent')
    delete_project(child_id, 'merge_child')
  end


end
