require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'veye'
require "stringio"

def capture_stdout
  begin
    # The output stream must be an IO-like object. In this case we capture it in
    # an in-memory IO object so we can return the string value. You can assign any
    # IO object here.
    previous_stdout, $stdout = $stdout, StringIO.new
    yield
    $stdout.string
  rescue => e
    $stderr.puts "Error during output capture: #{e}"
  ensure
    # Restore the previous value of stdout
    $stdout = previous_stdout
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end

class Minitest::Test
  # Add global extensions to the test case class here
end
