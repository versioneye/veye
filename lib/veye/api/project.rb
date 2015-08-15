module Veye
  module API
    module Project
      RESOURCE_PATH = "/projects"
      MAX_FILE_SIZE = 500000 # ~ 500kB

      #TODO: add throws
      def self.check_file(filename)
        file_path = File.absolute_path(filename)

        unless File.exists?(file_path)
          printf("%s: Cant read file `%s`",
                 "Error".color(:red),
                 "#{filename}".color(:yellow))
          return nil
        end

        file_size = File.size(file_path)
        unless file_size != 0 and file_size < MAX_FILE_SIZE
          p "Size of file is not acceptable: 0kb < x <= #{MAX_FILE_SIZE/1000}kb"
          return nil
        end

        file_path
      end

      def self.get_list(api_key)
        project_api = Resource.new(RESOURCE_PATH)
        qparams = {:params => {:api_key => api_key}}
        project_api.resource.get(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.upload(api_key, filename)
        project_api = Resource.new(RESOURCE_PATH)
        file_path = check_file(filename)
        return if file_path.nil?

        file_obj = File.open(file_path, 'rb')
        upload_data = {
          :upload   => file_obj,
          :api_key  => api_key
        }

        project_api.resource.post(upload_data) do |response, request, result, &block|
          JSONResponse.new(request, result, response)
        end
      end

      def self.update(api_key, project_key, filename)
        project_api = Resource.new("#{RESOURCE_PATH}/#{project_key}")
        file_path = check_file(filename)
        return if file_path.nil?

        file_obj = File.open(file_path, 'rb')
        upload_data = {
          :project_file   => file_obj,
          :api_key        => api_key
        }
        project_api.resource.post(upload_data) do |response, request, result, &block|
          JSONResponse.new(request, result, response)
        end
      end

      def self.get_project(api_key, project_key)
        if project_key.nil? or project_key.empty?
          printf("%s: %s",
                 "Error".color(:red),
                 "Not valid project_key: `#{project_key}`")
          return
        end

        project_api = Resource.new("#{RESOURCE_PATH}/#{project_key}")
        qparams = {:params => {:api_key => api_key}}
        project_api.resource.get(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.delete_project(api_key, project_key)
        project_api = Resource.new("#{RESOURCE_PATH}/#{project_key}")
        qparams = {:params => {:api_key => api_key}}

        project_api.resource.delete(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end
    end
  end
end
