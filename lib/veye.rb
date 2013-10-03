# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file
require 'veye/version.rb'
require 'veye/service.rb'
require 'veye/api.rb'
require 'veye/package.rb'
require 'veye/project.rb'
require 'veye/user.rb'
require 'veye/pagination.rb'

$global_options ||= nil 
DEFAULT_CONFIG_FILE = ".veye.rc"
DEFAULT_CONFIG_PATH = "~"

def get_config_fullpath
  File.expand_path("#{DEFAULT_CONFIG_PATH}/#{DEFAULT_CONFIG_FILE}")
end

def config_exists?
  filepath = get_config_fullpath
  File.exists?(filepath)
end

def check_config_file
  unless config_exists?
    msg = sprintf("%s: %s\n",
                  "config file doesnt exist. ".foreground(:red),
                  "Use `veye initconfig` to initialize settings file.")
    exit_now!(msg)
  end
end

def self.check_configs(global_opts)
  check_config_file
  check_api_key(global_opts)

  unless ssl_key_exists?(global_opts)
    generate_ssl_keys(global_opts)
  end
  true
end

def init_environment
    #sets up required variables and modules to work on IRB or unittest
    config_file = get_config_fullpath   
    $global_options = YAML.load_file(config_file)
    $global_options[:config_file] = config_file 
    $global_options[:url] = Veye::API::Resource.build_url($global_options)
    
    $global_options
end

def check_api_key(global_opts)
  result = false
  if global_opts[:api_key].nil? or global_opts[:api_key].match("add your api key")
    msg = sprintf("%s: %s\n",
                "Warning: API key is missing.".foreground(:yellow), 
                "You cant access private data.")
     print msg
  else
    result = true
  end

  result
end

def ssl_key_exists?(global_opts)
  fullpath = File.expand_path(global_opts[:ssl_path])
  return File.exists?("#{fullpath}/veye_cert.pem")
end

def generate_ssl_keys(global_opts)
  result = false
  key_command = %Q[
    openssl req -x509 -newkey rsa:2048 -keyout veye_key.pem -out veye_cert.pem -nodes
  ]

  Dir.chdir(Dir.home)
  ssl_path = File.expand_path(global_opts[:ssl_path])
  unless Dir.exists?(ssl_path)
    p "Creating folder for ssl keys: `#{ssl_path}`"
    Dir.mkdir(ssl_path)
  end

  Dir.chdir(ssl_path)
  if system(key_command)
    print "Key is generated.\n"
    result = true
  else
    print "Cant generate SSL keys. Do you have openssl installed?\n"
  end

  Dir.chdir(Dir.home)
  result
end

def save_configs
  filepath = get_config_fullpath
  File.open(filepath, 'w') do |f|
    f.puts $global_options.to_yaml
  end
  msg = sprintf("%s: %s",
         "Success".foreground(:green),
         "new settings are saved into file: `#{filepath}`\n")
  print msg
end
