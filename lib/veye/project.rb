require_relative 'project/check.rb'
require_relative 'project/license.rb'

module Veye
  # Project module includes commands for managing
  # projects on VersionEye and presenting results
  # on command line.
  module Project
    @supported_files = [
      'project\.clj', 'bower\.json', 'project\.json', 'gemfile',
      'gemfile\.lock', '*\.gradle', '*\.sbt', '*\.pom\.xml', 'podfile'
    ]

    def self.supported_files
      @supported_files
    end

    def self.supported?(filename)
      @supported_files.any? {|ptrn| filename.to_s.downcase.match(/^#{ptrn}$/) }  
    end

    #returns list of supported filenames in the working folder
    def self.get_files(path)
      files = Set.new
      Dir.foreach(path) do |filename|
        files << filename if supported?(filename)
      end

      if files.include?('Gemfile') and files.include?('Gemfile.lock')
        files.delete 'Gemfile'
      end

      files
    end
  end
end
