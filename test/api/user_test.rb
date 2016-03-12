require 'test_helper'

class UserTest < Minitest::Test
  def setup
    init_environment
    @api_key = ENV["VEYE_API_KEY"]
  end

  def test_get_profile_api_call
    VCR.use_cassette('user_get_profile') do
      res = Veye::API::User.get_profile(@api_key)
      refute_nil res
      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal "timgluz", res.data["username"]
      assert_equal "timgluz@gmail.com", res.data["email"]
    end
  end

  def test_get_favorites_api_call
    VCR.use_cassette("user_get_favorites") do
      res = Veye::API::User.get_favorites(@api_key)
      refute_nil res
      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal "h2", res.data['favorites'].first["name"]
    end
  end

end
