require_relative 'project/check.rb'
require_relative 'project/licence.rb'

module Veye
  module Project
    RESOURCE_PATH = "/projects"
    MAX_FILE_SIZE = 500000 # ~ 500kB
  end
end
