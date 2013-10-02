require 'json'

require_relative 'project_csv.rb'
require_relative 'project_json.rb'
require_relative 'project_pretty.rb'
require_relative 'project_table.rb'

require_relative 'project_dependency_csv.rb'
require_relative 'project_dependency_json.rb'
require_relative 'project_dependency_pretty.rb'
require_relative 'project_dependency_table.rb'

module Veye
  module Project
    class Check
      @@output_formats = {
        "csv"       => ProjectCSV.new,
        "json"      => ProjectJSON.new,
        "pretty"    => ProjectPretty.new,
        "table"     => ProjectTable.new
      }

      @@dependency_output_formats = {
        "csv"       => ProjectDependencyCSV.new,
        "json"      => ProjectDependencyJSON.new,
        "pretty"    => ProjectDependencyPretty.new,
        "table"     => ProjectDependencyTable.new
      }
      

      def self.get_list(api_key)
        project_api = API::Resource.new(RESOURCE_PATH)
        qparams = {:params => {:api_key => api_key}}

        project_api.resource.get(qparams) do |response, request, result|
          response_data = API::JSONResponse.new(request, result, response)
        end
      end

      def self.upload(filename, api_key)
        response_data = {:success => false}
        file_path = File.absolute_path(filename)
         
        unless File.exists?(file_path)
            error_msg = sprintf("%s: Cant read file `%s`", 
                                "Error".foreground(:red),
                                "#{filename}".foreground(:yellow)
                               )
            exit_now!(error_msg)
        end

        file_size = File.size(file_path)
        unless file_size != 0 and file_size < MAX_FILE_SIZE
            exit_now!("Size of file is not acceptable: 0kb < x <= #{MAX_FILE_SIZE/1000}kb")
        end
       
        project_api = API::Resource.new(RESOURCE_PATH)
        file_obj = File.open(file_path, 'rb')
        
        upload_data = {
          :upload   => file_obj,
          :api_key  => api_key
        }
        project_api.resource.post(upload_data) do |response, request, result, &block|
          response_data = API::JSONResponse.new(request, result, response)
        end
        
        return response_data
      end

      def self.update(project_key, filename, api_key)
        response_data = {:success => false}
        file_path = File.absolute_path(filename)
         
        unless File.exists?(file_path)
          error_msg = sprintf("%s: Cant read file `%s`", 
                              "Error".foreground(:red),
                              "#{filename}".foreground(:yellow)
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
          response_data = API::JSONResponse.new(request, result, response)
        end
      end 
      def self.get_project(project_key, api_key)
        response_data = nil
        project_api = API::Resource.new(RESOURCE_PATH)
        
        if project_key.nil? or project_key.empty? 
          error_msg = sprintf("%s: %s",
                             "Error".foreground(:red),
                             "Not valid project_key: `#{project_key}`")          
          exit_now! error_msg
        end
        
        project_url = "/#{project_key}"
        qparams = {:params => {:api_key => api_key}}
        project_api.resource[project_url].get(qparams) do |response, request, result|
          response_data = API::JSONResponse.new(request, result, response)
        end

        return response_data
      end

      def self.delete_project(project_key, api_key)
        project_api = Veye::API::Resource.new(RESOURCE_PATH)
        qparams = {:params => {:api_key => api_key}}
        response_data = nil

        project_api.resource["/#{project_key}"].delete(qparams) do |response, request, result|
          response_data = API::JSONResponse.new(request, result, response)
        end

        return response_data
      end

      def self.format(results, format = 'pretty')
        formatter = @@output_formats[format]
        formatter.before
        formatter.format results
        formatter.after
      end
      
      def self.format_dependencies(results, format = 'pretty')
        formatter = @@dependency_output_formats[format]
        formatter.before
        formatter.format results
        formatter.after
      end

    end
  end
end

