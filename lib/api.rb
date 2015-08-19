require 'veye/api'

# -- initialize global options
$global_options = {
  protocol: 'https',
  server: 'www.versioneye.com',
  path: 'api/v2/',
  port: nil
}
$global_options[:url] = Veye::API::Resource.build_url($global_options)

module Veye
  module API
  end
end
