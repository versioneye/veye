require 'test_helper'

class GithubTest < Minitest::Test
  def setup
    init_environment
    @api_key = 'ba7d93beb5de7820764e'
  end

  def test_api_call
    VCR.use_cassette('github_list') do
      res = Veye::API::Github.get_list(@api_key)
      refute_nil res
      assert_equal 200, res.code
      repo = res.data["repos"][0]
      assert_equal "versioneye_update", repo["name"]
      assert_equal "shell", repo["language"]
      assert_equal "versioneye", repo["owner_login"]
      assert_equal "organization", repo["owner_type"]
      assert_equal false, repo["private"]
    end
  end


end
