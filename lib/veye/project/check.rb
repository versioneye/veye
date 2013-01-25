require 'json'

require_relative 'check_csv.rb'
require_relative 'check_json.rb'
require_relative 'check_pretty.rb'
require_relative 'check_table.rb'

require_relative 'project_list_csv.rb'
require_relative 'project_list_json.rb'
require_relative 'project_list_pretty.rb'
require_relative 'project_list_table.rb'

module Veye
  module Project
    class Check
      @@output_formats = {
        "csv"       => CheckCSV.new,
        "json"      => CheckJSON.new,
        "pretty"    => CheckPretty.new,
        "table"     => CheckTable.new
      }

      @@list_output_formats = {
        "csv"       => ProjectListCSV.new,
        "json"      => ProjectListJSON.new,
        "pretty"    => ProjectListPretty.new,
        "table"     => ProjectListTable.new
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

      def self.dependencies(project_key, api_key)
        response_data = nil
        project_api = API::Resource.new(RESOURCE_PATH)
        
        if project_key.nil? or project_key.empty? 
            exit_now!("Didnt get right project_id from service: `#{project_key}`")
        end
        
        project_url = "/#{project_key}.json"
        project_api.resource[project_url].get(api_key: api_key) do |response, request, result|
           response_data = API::JSONResponse.new(request, result, response)
        end

        return response_data
      end

      def self.delete(project_key, api_key)
        project_api = Veye::API::Resource.new(RESOURCE_PATH)
        project_api.resource["/#{project_key}.json"].delete(api_key: api_key)
      end

      def self.format(results, format = 'pretty')
        formatter = @@output_formats[format]
        formatter.before
        formatter.format results
        formatter.after
      end
      
      def self.format_list(results, format = 'pretty')
        formatter = @@list_output_formats[format]
        formatter.before
        formatter.format results
        formatter.after
      end

    end
  end
end

