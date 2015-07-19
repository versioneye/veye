require_relative '../views/project.rb'
require_relative '../base_executor.rb'

module Veye
  module Project
    module API
      def self.get_list(api_key)
        project_api = Veye::API::Resource.new(RESOURCE_PATH)
        qparams = {:params => {:api_key => api_key}}
        project_api.resource.get(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end

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

      def self.upload(filename, api_key)
        project_api = Veye::API::Resource.new(RESOURCE_PATH)
        file_path = check_file(filename)
        return if file_path.nil?

        file_obj = File.open(file_path, 'rb')
        upload_data = {
          :upload   => file_obj,
          :api_key  => api_key
        }

        project_api.resource.post(upload_data) do |response, request, result, &block|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end

      def self.update(project_key, filename, api_key)
        project_api = Veye::API::Resource.new("#{RESOURCE_PATH}/#{project_key}")
        file_path = check_file(filename)
        return if file_path.nil? 

        file_obj = File.open(file_path, 'rb')
        upload_data = {
          :project_file   => file_obj,
          :api_key        => api_key
        }
        project_api.resource.post(upload_data) do |response, request, result, &block|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end

      def self.get_project(project_key, api_key)
        if project_key.nil? or project_key.empty?
          printf("%s: %s",
                 "Error".color(:red),
                 "Not valid project_key: `#{project_key}`")
          return
        end

        project_api = Veye::API::Resource.new("#{RESOURCE_PATH}/#{project_key}")
        qparams = {:params => {:api_key => api_key}}
        project_api.resource.get(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end

      def self.delete_project(project_key, api_key)
        project_api = Veye::API::Resource.new("#{RESOURCE_PATH}/#{project_key}")
        qparams = {:params => {:api_key => api_key}}

        project_api.resource.delete(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end 
    end

    class Check < BaseExecutor
      extend FormatHelpers

      @@output_formats = {
        "csv"       => Project::InfoCSV.new,
        "json"      => Project::InfoJSON.new,
        "pretty"    => Project::InfoPretty.new,
        "table"     => Project::InfoTable.new,
        "md"        => Project::InfoMarkdown.new
      }

      @@dependency_output_formats = {
        "csv"       => Project::DependencyCSV.new,
        "json"      => Project::DependencyJSON.new,
        "pretty"    => Project::DependencyPretty.new,
        "table"     => Project::DependencyTable.new,
        "md"        => Project::DependencyMarkdown.new
      }

      def self.get_list(api_key, options)
        results = API.get_list(api_key)
        catch_request_error(results, "Can not read list of projects.")
        show_results(@@output_formats, results.data, options)
      end

      def self.upload(filename, api_key, options)
        results = API.upload(filename, api_key)

        catch_request_error(results, "Upload failed.")
        show_results(@@output_formats, results.data, options)
        show_dependencies(results.data, options)
      end

      def self.update(project_key, filename, api_key, options)
        results = API.update(project_key, filename, api_key)
        catch_request_error(results, "Re-upload failed.")
        show_results(@@output_formats, results.data, options)
        show_dependencies(results.data, options)
      end

      def self.get_project(project_key, api_key, options)
        results = API.get_project(project_key, api_key)
        err_msg = "No data for the project: `#{project_key}`"
        catch_request_error(results, err_msg)
        show_results(@@output_formats, results.data, options)
        show_dependencies(results.data, options)
        results
      end

      def self.delete_project(project_key, api_key)
        results = Veye::Project::API.delete_project(project_key, api_key)
        catch_request_error(results, "Failed to delete project: `#{project_key}`")
        show_message(results, "Deleted", "Cant delete.")
        results
      end
      
      #-- layout helpers
      def self.show_dependencies(results, options)
        format = options[:format]
        format ||= 'pretty'
        return if format == 'json'
        self.supported_format?(@@dependency_output_formats, format)

        formatter = @@dependency_output_formats[format]

        formatter.before
        formatter.format results['dependencies']
        formatter.after
      end

      def self.show_message(results, success_msg, fail_msg)
        unless results.success
          printf("Error: %s\n%s\n",
                 fail_message.color(:red),
                 response.data['error'])
        else
          printf "#{success_msg}\n".color(:green)
        end
      end
    end
  end
end
