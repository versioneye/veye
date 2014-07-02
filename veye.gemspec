# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','veye','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'veye'
  s.version = Veye::VERSION
  s.author = 'VersionEye GMBH'
  s.authors = ['VersionEye GMBH', "@timgluz", "@robertreiz"]
  s.email = 'reiz@versioneye.com'
  s.homepage = 'https://github.com/versioneye/veye'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Commandline tool for VersionEye'
  s.description = %Q[
    Veye is commandline tool like Heroku has own ToolBelt,
    and purpose of this tool is to make developer\'s life even
    more simpler and keep you up-to-date with freshest packages.
  ]
  s.license = "MIT"
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

  s.add_development_dependency('rake',  '~> 10.3')
  s.add_development_dependency('rdoc',  '~> 4.1')
  s.add_development_dependency('aruba', '~> 0.6')

  s.add_runtime_dependency('gli',               '~> 2.11')
  s.add_runtime_dependency('rest-client',       '~> 1.6')
  s.add_runtime_dependency('awesome_print',     '~> 1.2')
  s.add_runtime_dependency('rainbow',           '~> 2.0')
  s.add_runtime_dependency('terminal-table',    '~> 1.4')
  s.add_runtime_dependency('render-as-markdown','~> 0.0')
end
