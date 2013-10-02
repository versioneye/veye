require 'json'

require_relative 'project_licence_csv.rb'
require_relative 'project_licence_json.rb'
require_relative 'project_licence_pretty.rb'
require_relative 'project_licence_table.rb'

module Veye
  module Project
    class Licence
      @@output_formats = {
        "csv"     => ProjectLicenceCSV.new,
        "json"    => ProjectLicenceJSON.new,
        "pretty"  => ProjectLicencePretty.new,
        "table"   => ProjectLicenceTable.new
      }

      def self.get_project(project_key, api_key)
        response_data = nil
        project_api = API::Resource.new(RESOURCE_PATH)
        
        if project_key.nil? or project_key.empty? 
          error_msg = sprintf("%s: %s",
                             "Error".foreground(:red),
                             "Not valid project_key: `#{project_key}`")          
          exit_now! error_msg
        end
        
        project_url = "/#{project_key}/licenses"
        qparams = {:params => {:api_key => api_key}}
        project_api.resource[project_url].get(qparams) do |response, request, result|
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
 
    end
  end
end

