require 'test_helper'

class ServiceTest < Minitest::Test
  def setup
    init_environment #load config file and set keys
  end

  def teardown
  end

  def test_ping_api_call
    VCR.use_cassette('services_ping') do
      resp = Veye::API.ping
      assert_equal 200, resp.code
      assert_equal 'pong', resp.data['message']
    end
  end

  def test_ping_output_when_success
    VCR.use_cassette('services_ping') do
      resp = Veye::API.ping
      output = capture_stdout do
        Veye::Service.show_result(resp)
      end
      assert_equal "\e[32mpong\e[0m\n", output
    end
  end

  def test_ping_output_when_failure
    resp = Minitest::Mock.new
    resp.expect :success, false
    resp.expect :code, 503
    resp.expect :message, "Test request failure"
    resp.expect :nil? , false

    output = capture_stdout do
      Veye::Service.show_result(resp)
    end
    expected = "VersionEye didnt recognized secret word.Answered \e[31m503\e[0m, \e[33mTest request failure\e[0m\n"
    assert_equal expected, output
  end
end
