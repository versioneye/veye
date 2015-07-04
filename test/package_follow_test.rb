require 'test_helper'

class PackageFollowTest < MiniTest::Test
  def setup
    init_environment
    @api_key = "ba7d93beb5de7820764e"
  end

  def test_get_follow_status_api_call
    VCR.use_cassette('package_follow_status') do
      res = Veye::Package::API.get_follow_status('ruby/ruby', @api_key)
      refute_nil res
      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal "ruby", res.data["prod_key"]
      assert_equal false, res.data["follows"]
    end
  end

  def test_follow_api_call
    VCR.use_cassette('package_follow') do
      res = Veye::Package::API.follow('ruby/ruby', @api_key)
      refute_nil res
      assert_equal 201, res.code
      assert_equal true, res.success
      assert_equal "ruby", res.data["prod_key"]
      assert_equal true, res.data["follows"]
    end
  end

  def test_unfollow_api_call
    VCR.use_cassette('package_unfollow') do
      res = Veye::Package::API.unfollow('ruby/ruby', @api_key)
      refute_nil res
      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal "ruby", res.data["prod_key"]
      assert_equal false, res.data["follows"]
    end
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
