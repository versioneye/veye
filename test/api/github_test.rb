require 'test_helper'

class GithubTest < Minitest::Test
  def setup
    init_environment
    @api_key = 'ba7d93beb5de7820764e'
    @repo_name = 'versioneye/veye'
  end

  def test_list_api
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

  def test_sync_api
    VCR.use_cassette('github_sync') do
      resp = Veye::API::Github.import_all(@api_key)
      refute_nil resp
      assert_equal 200, resp.code
      assert_equal( {"status"=>"running"}, resp.data )
    end
  end

  def test_info_api
    VCR.use_cassette('github_info') do
      res = Veye::API::Github.get_repo(@api_key, @repo_name)
      refute_nil res
      assert_equal 200, res.code
      repo = res.data["repo"]
      assert_equal "versioneye/veye", repo["fullname"]
      assert_equal "ruby", repo["language"]
      assert_equal "versioneye", repo["owner_login"]
      assert_equal false, repo["private"]
      assert_equal false, repo["fork"]
      assert_equal [], res.data["imported_projects"]
    end
  end


end
