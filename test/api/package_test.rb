require_relative '../test_helper'

class PackageTest < Minitest::Test
  def setup
    init_environment
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

end
