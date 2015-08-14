require 'test_helper'
require 'csv'

class GithubImportTest < Minitest::Test
  def setup
    init_environment
    @api_key = 'ba7d93beb5de7820764e'
    @repo_name = 'versioneye/veye'
    @branch = "master"
    @file = "Gemfile.lock"

    @opts = {
      file: @file,
      branch: @branch
    }
  end

  def test_api_call
    VCR.use_cassette('github_import') do
      res = Veye::Github::API.import_repo(@api_key, @repo_name, @branch, @file)
      refute_nil res
      assert_equal 201, res.code
      repo = res.data["repo"]

      assert_equal "veye", repo["name"]
      assert_equal "versioneye/veye", repo["fullname"]
      assert_equal "ruby", repo["language"]
      assert_equal "versioneye", repo["owner_login"]
      assert_equal "organization", repo["owner_type"]
      assert_equal false, repo["private"]
      assert_equal false, repo["fork"]

      project = res.data["imported_projects"].first
      refute_nil project, "imported_projects fields is missing"
      assert_equal "rubygem_versioneye_veye_1", project["project_key"]
      assert_equal "versioneye/veye", project["name"]
      assert_equal "RubyGem", project["project_type"]
      assert_equal true, project["public"]
      assert_equal "github", project["source"]
    end
  end

  def test_import_default
    VCR.use_cassette('github_import') do
      res = capture_stdout do
        Veye::Github::Import.import_repo(@api_key, @repo_name, @opts)
      end

      refute_nil res, "Command output was nil"
      rows = res.split(/\n/)
      assert_equal "\t\e[32mversioneye/veye\e[0m - \e[1mruby\e[0m", rows[0]
      assert_equal "\tDescription    : VersionEye command line tool ", rows[1]
      assert_equal "\tOwner login    : versioneye", rows[2]
      assert_equal "\tOwner type     : organization", rows[3]
      assert_equal "\tPrivate        : false", rows[4]
      assert_equal "\tFork           : false", rows[5]
      assert_equal "\tBranches       : ", rows[6]
      assert_equal "\tImported       : rubygem_versioneye_veye_1", rows[7]
    end
  end

  def test_import_csv
    VCR.use_cassette('github_import') do
      res = capture_stdout do
        Veye::Github::Import.import_repo(@api_key, @repo_name, @opts.merge({format: 'csv'}))
      end

      refute_nil res, "Command output was nil"
      dt = CSV.parse(res)
      assert_equal ["name", "language", "owner_login", "owner_type", "private", "fork", "branches", "imported_projects", "description"], dt[0]
      assert_equal ["versioneye/veye", "ruby", "versioneye", "organization", "false"], dt[1].take(5)
      assert_equal ["false", nil, "rubygem_versioneye_veye_1", "VersionEye command line tool "], dt[1].drop(5)
    end
  end

  def test_import_json
    VCR.use_cassette('github_import') do
      res = capture_stdout do
        Veye::Github::Import.import_repo(@api_key, @repo_name, @opts.merge({format: 'json'}))
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
      assert_equal "rubygem_versioneye_veye_1", project["project_key"]
      assert_equal "versioneye/veye", project["name"]
      assert_equal "RubyGem", project["project_type"]
      assert_equal true, project["public"]
      assert_equal "github", project["source"]
    end
  end

  def test_import_table
    VCR.use_cassette('github_import') do
      res = capture_stdout do
        Veye::Github::Import.import_repo(@api_key, @repo_name, @opts.merge({format: 'table'}))
      end

      refute_nil res, "No command output"
      rows = res.split(/\n/)
      assert_match(/\|\s+Repository information\s+\|/, rows[1])
      assert_match(/\| name\s+\| language \| owner_login \| owner_type\s+\| private \| fork\s+\|/ , rows[3])
      assert_match(/branches \| imported_projects\s+\| description\s+\|/, rows[3])
      assert_match(/\| versioneye \| veye | ruby\s+\| versioneye  \| organization \| false/, rows[5])
      assert_match(/\| false \|\s+\| rubygem_versioneye_veye_1 \| VersionEye command line tool\s+\|/, rows[5])
    end
  end
end
