require 'test_helper'

class GithubDeleteTest < Minitest::Test
  def setup
    init_environment
    @api_key = ENV['VEYE_API_KEY']
    @repo_name = 'versioneye/veye'
    @branch = "master"
    @filename = 'Gemfile.lock'

    import_project
  end

  def import_project
    #import project before testing
    VCR.use_cassette('github_import') do
      res = Veye::API::Github.import_repo(@api_key, @repo_name, @branch, @filename)      

      refute_nil res, "Import failed"
    end
  end

  def test_delete_default
    VCR.use_cassette('github_delete') do
      res = capture_stdout do 
        Veye::Github::Delete.delete_repo(@api_key, @repo_name, @branch, {})
      end

      refute_nil res, "No command output"
      assert_equal "\e[32mDeleted\n\e[0m", res
    end
  end
end
