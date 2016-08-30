module Veye
  module API
    module Project
      RESOURCE_PATH = "/projects"
      MAX_FILE_SIZE = 500000 # ~ 500kB

      #TODO: add throws
      def self.check_file(filename)
        file_path = File.absolute_path(filename)

        unless File.exist?(file_path)
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

      def self.get_list(api_key, org_name, team_name = nil)
        project_api = Resource.new(RESOURCE_PATH)
        qparams = {:api_key => api_key}
        qparams[:orga_name] = org_name.to_s.strip unless org_name.to_s.empty?
        qparams[:team_name] = team_name.to_s.strip unless team_name.to_s.empty?

        project_api.resource.get({:params => qparams}) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.upload(api_key, filename, org_name = nil, team_name = nil, temporary = false, public =true, name = nil)
        project_api = Resource.new(RESOURCE_PATH)
        file_path = check_file(filename)
        return if file_path.nil?

        file_obj = File.open(file_path, 'rb')
        upload_data = {
          :upload   => file_obj,
          :api_key  => api_key
        }
        upload_data[:orga_name] = org_name.to_s.strip unless org_name.to_s.empty?
        upload_data[:team_name] = team_name.to_s.strip unless team_name.to_s.empty?
        upload_data[:temporary] = temporary
        upload_data[:visibility] = (public == true ? 'public' : 'private')
        upload_data[:name]      = name.to_s.strip unless name.to_s.strip.empty?

        project_api.resource.post(upload_data) do |response, request, result, &block|
          JSONResponse.new(request, result, response)
        end
      end

      def self.update(api_key, project_id, filename)
        project_api = Resource.new("#{RESOURCE_PATH}/#{project_id}")
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

      #TODO: add throw exceptions
      def self.get_licenses(api_key, project_key)
        if project_key.nil? or project_key.empty?
          printf("%s: %s",
                 "Error".color(:red),
                 "Not valid project_key: `#{project_key}`")
          return
        end
        project_api = Resource.new("#{RESOURCE_PATH}/#{project_key}/licenses")
        qparams = {:params => {:api_key => api_key}}
        project_api.resource.get(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

    end
  end
end
