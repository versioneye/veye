require_relative '../views/project.rb'
require_relative '../base_executor.rb'

module Veye
  module Project
    class Licence < BaseExecutor
      @@output_formats = {
        "csv"     => Project::LicenceCSV.new,
        "json"    => Project::LicenceJSON.new,
        "pretty"  => Project::LicencePretty.new,
        "table"   => Project::LicenceTable.new
      }

      def self.get_project(project_key, api_key, options)
        results = nil
        project_api = API::Resource.new(RESOURCE_PATH)

        if project_key.nil? or project_key.empty?
          error_msg = sprintf("%s: %s",
                             "Error".color(:red),
                             "Not valid project_key: `#{project_key}`")
          exit_now! error_msg
        end

        project_url = "/#{project_key}/licenses"
        qparams = {:params => {:api_key => api_key}}
        project_api.resource[project_url].get(qparams) do |response, request, result|
          results = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(results, "Cant access a information for project `#{project_key}.")
        show_results(@@output_formats, results.data, options)
        results
      end
    end
  end
end

