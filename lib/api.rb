require 'veye/api'

module Veye
  module API
    $global_options = {
      protocol: 'https',
      server: 'www.versioneye.com',
      path: 'api/v2/',
      port: nil
    }
    $global_options[:url] = Resource.build_url($global_options)
  end
end
