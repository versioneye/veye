require_relative '../views/project.rb'
require_relative '../base_executor.rb'

module Veye
  module Project
    # Licence class holds commands for checking licenses in the project.
    class License < BaseExecutor
      @output_formats = {
        'csv'     => Project::LicenceCSV.new,
        'json'    => Project::LicenceJSON.new,
        'pretty'  => Project::LicencePretty.new,
        'table'   => Project::LicenceTable.new
      }

      def self.get_licenses(project_key, api_key, options)
        results = Veye::API::Project.get_licenses(api_key, project_key)
        err_msg = "Cant access a information for project `#{project_key}`."
        catch_request_error(results, err_msg)
        show_results(@output_formats, results.data, options)
      end
    end
  end
end
