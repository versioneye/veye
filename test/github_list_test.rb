require 'test_helper'
require 'csv'

class GithubListTest < Minitest::Test
  def setup
    init_environment
    @api_key = 'ba7d93beb5de7820764e'
  end

  def test_get_list_default
    VCR.use_cassette('github_list') do
      output = capture_stdout do
        Veye::Github::List.get_list(@api_key, {})
      end

      refute_nil output
      rows = output.split(/\n/)
      assert_equal "  1 - \e[32m\e[1mversioneye_update\e[0m", rows[0]
      assert_equal "\tLanguage       : shell", rows[1]
      assert_equal "\tOwner name     : versioneye", rows[2]
      assert_equal "\tOwner type     : organization", rows[3]
      assert_equal "\tPrivate        : false", rows[4]
      assert_equal "\tFork           : false", rows[5]
      assert_equal "\tBranches       : ", rows[6]
      assert_match(/\tDescription\s+:\s+\w+/, rows[7])
      assert_equal "\tImported       : ", rows[8]
    end
  end

  def test_get_list_csv
    VCR.use_cassette('github_list') do
      output = capture_stdout do
        Veye::Github::List.get_list(@api_key, {format: 'csv'})
      end

      refute_nil output
      rows = CSV.parse(output)
      assert_equal ["nr", "fullname", "language", "owner_login", "owner_type"], rows[0].take(5)
      assert_equal ["private", "fork", "branches", "imported", "description"], rows[0].drop(5)
      
      assert_equal ["1", "versioneye/versioneye_update", "shell", "versioneye", "organization"], rows[1].take(5)
      assert_equal ["false", "false", nil, nil, "Update an existing project at VersionEye via the API with CURL"], rows[1].drop(5)
    end
  end

  def test_get_list_json
    VCR.use_cassette('github_list') do
      output = capture_stdout do
        Veye::Github::List.get_list(@api_key, {format: 'json'})
      end

      refute_nil output
      dt = JSON.parse(output)
      item = dt["repos"][0]
      assert_equal "versioneye_update", item["name"]
      assert_equal "shell", item["language"]
      assert_equal "versioneye", item["owner_login"]
      assert_equal "organization", item["owner_type"]
      assert_equal false, item["private"]
      assert_equal false, item["fork"]
      assert_equal nil, item["branches"]
      assert_equal nil, item["imported"]
    end
  end

  def test_get_list_table
    VCR.use_cassette('github_list') do
      output = capture_stdout do
        Veye::Github::List.get_list(@api_key, {format: 'table'})
      end

      refute_nil output
      rows = output.split(/\n/)
      assert_match /\A\+\-.*/, rows[0]
      assert_match( /\| index \| fullname\s+\| language\s+\| owner_login\s+/, rows[3])
      assert_match(/\| owner_type\s+\| private \| fork\s+\| branches \| imported \|/,
                   rows[3])

      assert_match(/ 1\s+\| versioneye\/versioneye_update\s+\| shell\s+\|/, rows[5])
      assert_match(/\| versioneye\s+\| organization\s+\| false\s+\| false \|\s+\|\s+\|/, rows[5])
    end
  end
end

