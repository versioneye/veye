require 'test_helper'

class GithubSyncTest < Minitest::Test
  def setup
    init_environment # load config files and initialize options
    @api_key = ENV['VEYE_API_KEY']
  end

  def test_sync_when_success
    VCR.use_cassette('github_sync') do
      output = capture_stdout do
        Veye::Github::Sync.import_all(@api_key, {})
      end

      refute_nil output
      expected_str = "\e[31mNo changes.\e[0m - Use `force` flag if you want to reload everything.\n"
      assert_equal expected_str, output
    end
  end
end
