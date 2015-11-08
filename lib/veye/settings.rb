require 'json'

module Veye

  #This class includes methods to manage project specific
  # settings to make it recurrent usage simpler for users
  class Settings
    @filename = "veye.json"
    @default_options = {
      projects: {} #file_name : project_key
    }

    def self.filename
      @filename
    end

    def self.default_options
      @default_options
    end

    def self.file_fullpath(path)
      path ||= Dir.pwd
      file_path = "#{path}/#{@filename}"
      File.absolute_path(file_path)
    end

    #read config file from current working directory
    #it returns nil if settings file doesnt exists or not readable
    #otherwise it returns a map of settings
    def self.load(path)
      file_path = file_fullpath(path)
      return unless File.exists?(file_path)
      JSON.load(File.open(file_path, 'r'))
    end

    #saves map of options into settings file
    #ps: it overwrites whole content in settings file
    def self.dump(path, options)
      file_path = file_fullpath(path)
      File.open(file_path, 'w') {|f| f.write(options.to_json) }
    end

    #initializes default VersionEye settings file and saves it into the file
    def self.init(path, options)
      opts = @default_options.merge(options)
      dump(path, opts)
      opts
    end
  end
end
