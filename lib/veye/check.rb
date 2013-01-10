require 'json'
require_relative 'format/check_csv.rb'
require_relative 'format/check_json.rb'
require_relative 'format/check_pretty.rb'
require_relative 'format/check_table.rb'

module Veye
  module Project

    RESOURCE_PATH = "/projects"
    MAX_FILE_SIZE = 500000 #byte ~ 500kb
    class Check
      @@output_formats = {
        "csv"       => Veye::Format::CheckCSV.new,
        "json"      => Veye::Format::CheckJSON.new,
        "pretty"    => Veye::Format::CheckPretty.new,
        "table"     => Veye::Format::CheckTable.new
      }

      def self.upload(filename)
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
       
        project_api = Veye::API::Resource.new(RESOURCE_PATH)
        file_obj = File.open(file_path, 'rb')
        project_api.resource.post({:upload => file_obj}) do |response, request, result, &block|
            response = JSON.parse(response)
            success = false
            success = response[:success] if (result.code.to_i == 200)
            response_data = {
              :success => success,
              :results => response["data"]
            }
        end
        
        return response_data
      end

      def self.dependencies(project_id)
        response_data = nil
        project_api = Veye::API::Resource.new(RESOURCE_PATH)
        
        if project_id.nil? or project_id.empty? 
            exit_now!("Didnt get right project_id from service: `#{project_id}`")
        end
        
        project_url = "/#{project_id}/dependencies"
        project_api.resource[project_url].get do |response, request, result|
            response = JSON.parse(response)
            response_data = {
                :success => (result.code.to_i == 200),
                :results => response["data"]
            }
        end

        return response_data
      end

      def self.delete(project_id)
        project_api = Veye::API::Resource.new(RESOURCE_PATH)
        project_api.resource["/#{project_id}.json"].delete
      end

      def self.format(results, format = 'pretty')
        formatter = @@output_formats[format]
        formatter.before
        formatter.format results
        formatter.after
      end

    end
  end
end

