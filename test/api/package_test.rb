require_relative '../test_helper'

class PackageTest < Minitest::Test
  def setup
    init_environment
    @api_key = "ba7d93beb5de7820764e"
  end

  def test_info_api_call
    VCR.use_cassette('package_info') do
      res = Veye::API::Package::get_package('veye', 'ruby')

      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal "veye", res.data["name"]
      assert_equal "ruby", res.data["language"]
      assert_equal "veye", res.data["prod_key"]
    end
  end

  def test_search_api_call
    VCR.use_cassette('package_search') do
      res = Veye::API::Package.search('veye')
      refute_nil res
      assert_equal true, res.success
      assert_equal 200, res.code
      refute_nil res.data["results"], "Search results are empty"
      dt = res.data["results"].first
      assert_equal "veye", dt["name"]
      assert_equal "ruby", dt["language"]
      assert_equal "veye", dt["prod_key"]
      assert_equal "RubyGem", dt["prod_type"]
    end
  end

  def test_get_follow_status_api_call
    VCR.use_cassette('package_follow_status') do
      res = Veye::API::Package.get_follow_status(@api_key, 'ruby', 'ruby')
      refute_nil res
      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal "ruby", res.data["prod_key"]
      assert_equal false, res.data["follows"]
    end
  end

  def test_follow_api_call
    VCR.use_cassette('package_follow') do
      res = Veye::API::Package.follow(@api_key, 'ruby', 'ruby')
      refute_nil res
      assert_equal 201, res.code
      assert_equal true, res.success
      assert_equal "ruby", res.data["prod_key"]
      assert_equal true, res.data["follows"]
    end
  end

  def test_unfollow_api_call
    VCR.use_cassette('package_unfollow') do
      res = Veye::API::Package.unfollow(@api_key, 'ruby', 'ruby')
      refute_nil res
      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal "ruby", res.data["prod_key"]
      assert_equal false, res.data["follows"]
    end
  end

end
