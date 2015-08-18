require_relative '../views/github.rb'
require_relative '../base_executor.rb'

module Veye
  module Github
    # Info class includes methods to fetch the project info on VersionEye
    class Info < BaseExecutor
      @output_formats = {
        'csv'     => Github::InfoCSV.new,
        'json'    => Github::InfoJSON.new,
        'pretty'  => Github::InfoPretty.new,
        'table'   => Github::InfoTable.new
      }

      def self.get_repo(api_key, repo_name, options)
        results = Veye::API::Github.get_repo(
          api_key, repo_name, options[:branch], options[:file]
        )
        catch_request_error(results, "Can not find repository `#{repo_name}`")
        show_results @output_formats, results.data, options
      end
    end
  end
end
