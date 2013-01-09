# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file
require 'veye/version.rb'
require 'veye/resource.rb'
require 'veye/info.rb'
require 'veye/search.rb'
require 'veye/service.rb'
require 'veye/check.rb'


$global_options ||= nil 
def init_environment
    #sets up required variables and modules to work on IRB or unittest
    config_file = "#{ENV["HOME"]}/.veye.rc"
    $global_options = YAML.load_file(config_file)
    $global_options[:url] = Veye::API::Resource.build_url($global_options)
    
end
