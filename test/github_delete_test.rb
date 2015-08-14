require 'test_helper'

class GithubDeleteTest < Minitest::Test
  def setup
    init_environment
    @api_key = 'ba7d93beb5de7820764e'
    @repo_name = 'versioneye/veye'
    @branch = "master"
    @opts = {branch: @branch}

    import_project
  end

  def import_project
    #import project before testing
    VCR.use_cassette('github_import') do
      res = Veye::Github::API.import_repo(@api_key, @repo_name, @branch, 'Gemfile.locl')
    end
  end

  def test_api_call
    VCR.use_cassette('github_delete') do
      res = Veye::Github::API.delete_repo(@api_key, @repo_name, @branch)

      refute_nil res, "No API response"
      assert_equal 200, res.code
      assert_equal true, res.data["success"]
    end
  end

  def test_delete_default
    VCR.use_cassette('github_delete') do
      res = capture_stdout do 
        Veye::Github::Delete.delete_repo(@api_key, @repo_name, @opts)
      end

      refute_nil res, "No command output"
      assert_equal "\e[32mDeleted\n\e[0m", res
    end
  end
end
