require_relative '../test_helper'

class PackageTest < Minitest::Test
  def setup
    init_environment
  end

  def test_info_api_call
    VCR.use_cassette('package_info') do
      res = Veye::API::Package::get_package('ruby/veye', {})

      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal "veye", res.data["name"]
      assert_equal "ruby", res.data["language"]
      assert_equal "veye", res.data["prod_key"]
    end
  end


end
