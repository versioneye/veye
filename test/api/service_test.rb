require 'test_helper'

class ServiceTest < Minitest::Test
  def setup
    init_environment
  end

  def test_ping_api_call
    VCR.use_cassette('services_ping') do
      resp = Veye::API::Service.ping
      assert_equal 200, resp.code
      assert_equal 'pong', resp.data['message']
    end
  end
end
