require_relative '../views/project.rb'
require_relative '../base_executor.rb'

module Veye
  module Project
    module API
      def self.get_licenses(project_key, api_key)
        project_api = Veye::API::Resource.new(RESOURCE_PATH)

        if project_key.nil? or project_key.empty?
          printf("%s: %s",
                 "Error".color(:red),
                 "Not valid project_key: `#{project_key}`")
          exit
        end

        project_url = "/#{project_key}/licenses"
        qparams = {:params => {:api_key => api_key}}
        project_api.resource[project_url].get(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end
    end

    class License < BaseExecutor
      @@output_formats = {
        "csv"     => Project::LicenceCSV.new,
        "json"    => Project::LicenceJSON.new,
        "pretty"  => Project::LicencePretty.new,
        "table"   => Project::LicenceTable.new
      }

      def self.get_licenses(project_key, api_key, options)
        results = API.get_licenses(project_key, api_key)
        err_msg = "Cant access a information for project `#{project_key}."
        catch_request_error(results, err_msg)
        show_results(@@output_formats, results.data, options)
      end
    end
  end
end
