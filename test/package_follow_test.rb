require 'test_helper'

class PackageFollowTest < MiniTest::Test
  def setup
    init_environment
    @api_key = "ba7d93beb5de7820764e"
  end

  def test_get_follow_status
    VCR.use_cassette('package_follow_status') do
      out = capture_stdout do
        Veye::Package::Follow.get_follow_status('ruby/ruby', @api_key)
      end
      expected = "\e[32mFollowing `ruby`: false\n\e[0m"
      assert_equal expected, out
    end
  end

  def test_follow
    VCR.use_cassette('package_follow') do
      out = capture_stdout do
        Veye::Package::Follow.follow('ruby/ruby', @api_key)
      end
      expected = "\e[32mFollowing `ruby`: true\n\e[0m"
      assert_equal expected, out
    end
  end

  def test_unfollow
    VCR.use_cassette('package_unfollow') do
      out = capture_stdout do
        Veye::Package::Follow.unfollow('ruby/ruby', @api_key)
      end
      expected = "\e[32mFollowing `ruby`: false\n\e[0m"
      assert_equal expected, out
    end
  end
end
