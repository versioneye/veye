# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','veye','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'veye'
  s.version = Veye::VERSION
  s.author = 'VersionEye GMBH'
  s.email = 'contact@versioneye.com'
  s.homepage = 'http://www.versioneye.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Commandline tool for VersionEye'
  s.description = <<-EOF
    Veye is commandline tool like Heroku has own ToolBelt, 
    and purpose of this tool is to make developer\'s life even
    more simpler and keep you up-to-date with freshest packages.
  EOF
  s.post_install_message = "Thanks for installing! To get more info, use: veye help"
# Add your other files here if you make them
  s.files = %w(lib/veye.rb)
  s.files += Dir['lib/**/*.rb'] + Dir['bin/*']
  s.files += Dir['[A-Z]*'] + Dir['test/**/*']
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','veye.rdoc']
  s.rdoc_options << '--title' << 'veye' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'veye'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.5.3')
  s.add_runtime_dependency('rest-client')
  s.add_runtime_dependency('awesome_print')
  s.add_runtime_dependency('rainbow')
end
