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

def self.check_configs(global_opts)
  unless config_exists?
    msg = sprintf("%s: %s\n",
                  "config file doesnt exist. ".foreground(:red),
                  "Use `veye initconfig` to initialize settings file.")
    exit_now!(msg)
  end
  check_api_key(global_opts)

  true
end

def init_environment
    #sets up required variables and modules to work on IRB or unittest
    config_file = get_config_fullpath   
    $global_options = YAML.load_file(config_file)
    $global[:config_file] = config_file 
    $global_options[:url] = Veye::API::Resource.build_url($global_options)  
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

def update_api_key
  user_key = gets.chomp.to_s.strip
  if user_key =~ /No/i
    msg = sprintf("%s: %s",
                  "Warning:".foreground(:yellow),
                  " missing, you cant access private data.")
    print msg
  else
    $global_options[:api_key] = user_key
    save_configs
  end
end

def save_configs
  filepath = get_config_fullpath
  File.open(filepath, 'w') do |f|
    f.puts $global_options.to_yaml
  end
  msg = sprintf("%s: %s",
         "Success".foreground(:green),
         "new settings are saved into file: `#{filepath}`")
  print msg
end
