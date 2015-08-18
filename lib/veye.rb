# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file
require 'openssl'
require 'rest-client'
require 'yaml'

require 'veye/helpers/format_helpers.rb'

require 'veye/version.rb'
require 'veye/service.rb'
require 'veye/api.rb'
require 'veye/package.rb'
require 'veye/project.rb'
require 'veye/user.rb'
require 'veye/github.rb'
require 'veye/pagination.rb'

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
  generate_ssl_keys(global_opts) unless ssl_key_exists?(global_opts)
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

def ssl_key_exists?(global_opts)
  fullpath = File.expand_path(global_opts[:ssl_path])
  File.exist?("#{fullpath}/veye_cert.pem")
end

def generate_ssl_keys(global_opts)
  result = false

  Dir.chdir(Dir.home)
  ssl_path = File.expand_path(global_opts[:ssl_path])
  unless Dir.exist?(ssl_path)
    print "Info: Creating folder for ssl keys: `#{ssl_path}`\n"
    Dir.mkdir(ssl_path)
  end

  Dir.chdir(ssl_path)

  key = OpenSSL::PKey::RSA.new 2048
  open('veye_key.pem', 'w') { |io| io.write(key.to_pem) }
  open('veye_cert.pem', 'w') { |io| io.write(key.public_key.to_pem) }

  if ssl_key_exists?(global_opts)
    print 'Success: SSL keys are generated.\n'
    result = true
  else
    print 'Error: Cant generate SSL keys. Do you have openssl installed?\n'
  end

  Dir.chdir(Dir.home)
  result
end

def save_configs
  filepath = get_config_fullpath
  File.open(filepath, 'w') do |f|
    f.puts $global_options.to_yaml
  end
  msg = format(
    "%s: %s",
    'Success'.color(:green),
    'new settings are saved into file: `#{filepath}`\n'
  )
  print msg
end
