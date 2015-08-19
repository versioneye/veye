require_relative 'api/resource'
require_relative 'api/json_response'
require_relative 'api/package'
require_relative 'api/project'
require_relative 'api/github'
require_relative 'api/service'
require_relative 'api/user'

# -- initialize global options
# ps: command line interface overwrites those variables with init_enviroment
$global_options = {
  protocol: 'https',
  server: 'www.versioneye.com',
  path: 'api/v2',
  port: nil,
  timeout: 30
}
$global_options[:url] = Veye::API::Resource.build_url($global_options)

module Veye
  module API
  end
end
