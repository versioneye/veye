# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file
require 'rest-client'
require 'yaml'

require 'veye/helpers/format_helpers.rb'

require 'veye/version'
require 'veye/service'
require 'veye/api'
require 'veye/package'
require 'veye/project'
require 'veye/user'
require 'veye/github'
require 'veye/pagination'
require 'veye/settings'

$global_options ||= {}
DEFAULT_CONFIG_FILE = '.veye.rc'
DEFAULT_CONFIG_PATH = '~'

def get_config_fullpath
  File.expand_path("#{DEFAULT_CONFIG_PATH}/#{DEFAULT_CONFIG_FILE}")
end

def config_exists?
  filepath = get_config_fullpath
  File.exist?(filepath)
end

def check_config_file
  unless config_exists?
    p format(
      "%s: %s\n",
      'config file doesnt exist.'.color(:red),
      'Use `veye initconfig` to initialize settings file.'
    )
    exit
  end
end

def self.check_configs(global_opts, needs_api_key)
  check_config_file
  check_api_key(global_opts) if needs_api_key
  true
end

def init_environment
  # sets up required variables and modules to work on IRB or unittest
  config_file = get_config_fullpath
  $global_options = YAML.load_file(config_file)
  $global_options[:config_file] = config_file
  $global_options[:url] = Veye::API::Resource.build_url($global_options)
  $global_options
end

def check_api_key(global_opts)
  result = false
  if global_opts[:api_key].nil? || global_opts[:api_key].match("add your api key")
    print format(
      "%s: %s\n",
      'Warning: API key is missing.'.color(:yellow),
      'You cant access private data.'
    )
  else
    result = true
  end

  result
end

def save_configs
  filepath = get_config_fullpath
  File.open(filepath, 'w') do |f|
    f.puts $global_options.to_yaml
  end
  print format(
    "%s: %s",
    'Success'.color(:green),
    "new settings are saved into file: `#{filepath}`"
  )
end
