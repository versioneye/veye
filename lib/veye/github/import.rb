require_relative '../views/github.rb'
require_relative '../base_executor.rb'

module Veye
  module Github
    # Import class includes methods to import projects from Github
    # and will check a state of dependencies.
    class Import < BaseExecutor
      @output_formats = {
        'csv'     => Github::InfoCSV.new,
        'json'    => Github::InfoJSON.new,
        'pretty'  => Github::InfoPretty.new,
        'table'   => Github::InfoTable.new
      }

      def self.import_repo(api_key, repo_name, options)
        results = Veye::API::Github.import_repo(
          api_key, repo_name, options[:branch], options[:file]
        )
        catch_request_error(results, "Can not find repository `#{repo_name}`")
        show_results(@output_formats, results.data, options, nil)
      end
    end
  end
end
