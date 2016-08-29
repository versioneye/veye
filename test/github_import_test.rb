require 'test_helper'
require 'csv'

class GithubImportTest < Minitest::Test
  def setup
    init_environment
    @api_key = ENV['VEYE_API_KEY']
    @repo_name = 'versioneye/veye'
    @branch = "master"
    @filename = "Gemfile.lock"
  end

  def test_import_default
    VCR.use_cassette('github_import') do
      res = capture_stdout do
        Veye::Github::Import.import_repo(@api_key, @repo_name, @branch, @filename)
      end

      refute_nil res, "Command output was nil"
      rows = res.split(/\n/)
      assert_equal "\t\e[32mversioneye/veye\e[0m - \e[1mruby\e[0m", rows[0]
      assert_equal "\tDescription    : VersionEye command line tool implemented in Ruby", rows[1]
      assert_equal "\tOwner login    : versioneye", rows[2]
      assert_equal "\tOwner type     : organization", rows[3]
      assert_equal "\tPrivate        : false", rows[4]
      assert_equal "\tFork           : false", rows[5]
      assert_equal "\tBranches       : ", rows[6]
    end
  end

  def test_import_csv
    VCR.use_cassette('github_import') do
      res = capture_stdout do
        Veye::Github::Import.import_repo(@api_key, @repo_name, @branch, @filename, {format: 'csv'})
      end

      refute_nil res, "Command output was nil"
      dt = CSV.parse(res)
      assert_equal ["name", "language", "owner_login", "owner_type", "private", "fork", "branches", "imported_projects", "description"], dt[0]
      assert_equal ["versioneye/veye", "ruby", "versioneye", "organization", "false"], dt[1].take(5)
      assert_equal ["false", nil, '57c3f017864739000eca5357|57c3f39712b5260016707bea',
                    "VersionEye command line tool implemented in Ruby"], dt[1].drop(5)
    end
  end

  def test_import_json
    VCR.use_cassette('github_import') do
      res = capture_stdout do
        Veye::Github::Import.import_repo(@api_key, @repo_name, @branch, @filename, {format: 'json'})
      end

      refute_nil res, "No command output"
      dt = JSON.parse(res)
      repo = dt["repo"]
      assert_equal "veye", repo["name"]
      assert_equal "versioneye/veye", repo["fullname"]
      assert_equal "ruby", repo["language"]
      assert_equal "versioneye", repo["owner_login"]
      assert_equal "organization", repo["owner_type"]
      assert_equal false, repo["private"]
      assert_equal false, repo["fork"]
      assert_equal nil, repo["branches"]

      refute_nil dt["projects"]
      project = dt["projects"].first
      assert_equal "versioneye/veye", project["name"]
      assert_equal "RubyGem", project["project_type"]
      assert_equal true, project["public"]
      assert_equal "github", project["source"]
    end
  end

  def test_import_table
    VCR.use_cassette('github_import') do
      res = capture_stdout do
        Veye::Github::Import.import_repo(@api_key, @repo_name, @branch, @filename, {format: 'table'})
      end

      refute_nil res, "No command output"
      rows = res.split(/\n/)
      assert_match(/\|\s+Repository information\s+\|/, rows[1])
      assert_match(/\| name\s+\| language \| owner_login \| owner_type\s+\| private \| fork\s+\|/ , rows[3])
      assert_match(/branches \| imported_projects\s+\| description\s+\|/, rows[3])
      assert_match(/\| versioneye \| veye | ruby\s+\| versioneye  \| organization \| false/, rows[5])
    end
  end
end
