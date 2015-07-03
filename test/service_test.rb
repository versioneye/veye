require 'test_helper'

class ServiceTest < Minitest::Test

  def setup
    init_environment #load config file and set keys
  end

  def teardown
  end

  def test_ping_api_call
    VCR.use_cassette('services_ping') do
      resp = Veye::Service.ping
      assert_equal 200, resp.code
      assert_equal 'pong', resp.data['message']
    end
  end

  def test_ping_output_when_success
    VCR.use_cassette('services_ping') do
      resp = Veye::Service.ping
      output = capture_stdout do
        Veye::Service.show_result(resp)
      end
      assert_equal "\e[32mpong\e[0m\n", output
    end
  end

  def test_ping_output_when_failure

    VCR.use_cassette('services_ping_failure') do
      stub_request(:any, /.*versioneye.*/).to_return(status: 404, body: '[]')
      resp = Veye::Service.ping
      output = capture_stdout do
        Veye::Service.show_result(resp)
      end
      assert_equal "VersionEye didnt recognized secret word.Answered \e[31m404\e[0m, \e[33m\e[0m\n", output
    end
  end
end
