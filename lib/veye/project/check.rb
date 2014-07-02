require_relative '../views/project.rb'
require_relative '../base_executor.rb'

module Veye
  module Project
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
        project_api = API::Resource.new(RESOURCE_PATH)
        qparams = {:params => {:api_key => api_key}}
        results = nil
        project_api.resource.get(qparams) do |response, request, result|
          results = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(results, "Can not read list of projects.")
        show_results(@@output_formats, results.data, options)
        results
      end

      def self.upload(filename, api_key, options)
        results = {:success => false}
        file_path = File.absolute_path(filename)

        unless File.exists?(file_path)
          error_msg = sprintf("%s: Cant read file `%s`",
                              "Error".color(:red),
                              "#{filename}".color(:yellow))
          exit_now!(error_msg)
        end

        file_size = File.size(file_path)
        unless file_size != 0 and file_size < MAX_FILE_SIZE
          exit_now!("Size of file is not acceptable: 0kb < x <= #{MAX_FILE_SIZE/1000}kb")
        end

        project_api = API::Resource.new(RESOURCE_PATH)
        puts "built new project_api successfully"

        file_obj = File.open(file_path, 'rb')

        upload_data = {
          :upload   => file_obj,
          :api_key  => api_key
        }
        project_api.resource.post(upload_data) do |response, request, result, &block|
          results = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(results, "Upload failed.")
        show_results(@@output_formats, results.data, options)
        show_dependencies(results.data, options)
        results
      end

      def self.update(project_key, filename, api_key, options)
        results = {:success => false}
        file_path = File.absolute_path(filename)

        unless File.exists?(file_path)
          error_msg = sprintf("%s: Cant read file `%s`",
                              "Error".color(:red),
                              "#{filename}".color(:yellow)
                             )
          exit_now!(error_msg)
        end

        file_size = File.size(file_path)
        unless file_size != 0 and file_size < MAX_FILE_SIZE
          exit_now!(" The size of file is not acceptable: 0kb < x <= #{MAX_FILE_SIZE/1000}kb")
        end

        project_api = API::Resource.new("#{RESOURCE_PATH}/#{project_key}")
        file_obj = File.open(file_path, 'rb')
        upload_data = {
          :project_file   => file_obj,
          :api_key        => api_key
        }
        project_api.resource.post(upload_data) do |response, request, result, &block|
          results = API::JSONResponse.new(request, result, response)
        end
        catch_request_error(results, "Re-upload failed.")
        show_results(@@output_formats, results.data, options)
        show_dependencies(results.data, options)
        results
      end
      def self.get_project(project_key, api_key, options)
        results = nil
        project_api = API::Resource.new(RESOURCE_PATH)

        if project_key.nil? or project_key.empty?
          error_msg = sprintf("%s: %s",
                             "Error".color(:red),
                             "Not valid project_key: `#{project_key}`")
          exit_now! error_msg
        end

        project_url = "/#{project_key}"
        qparams = {:params => {:api_key => api_key}}
        project_api.resource[project_url].get(qparams) do |response, request, result|
          results = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(results, "Cant read information about project: `#{project_key}`")
        show_results(@@output_formats, results.data, options)
        show_dependencies(results.data, options)
        results
      end

      def self.delete_project(project_key, api_key)
        project_api = Veye::API::Resource.new(RESOURCE_PATH)
        qparams = {:params => {:api_key => api_key}}
        results = nil

        project_api.resource["/#{project_key}"].delete(qparams) do |response, request, result|
          results = API::JSONResponse.new(request, result, response)
        end
        catch_request_error(results, "Cant delete project: `#{project_key}`")
        show_message(results, "Deleted", "Cant delete.")
        results
      end

      def self.show_dependencies(results, options)
        format = options[:format]
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

