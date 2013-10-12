require_relative '../views/github.rb'
require_relative '../base_executor.rb'

module Veye
  module Github
    class Import < BaseExecutor
      @@output_formats = {
        'csv'     => Github::InfoCSV.new,
        'json'    => Github::InfoJSON.new,
        'pretty'  => Github::InfoPretty.new,
        'table'   => Github::InfoTable.new
      }

      def self.import_repo(api_key, repo_name, options)
        github_api = API::Resource.new(RESOURCE_PATH)
        results = nil
        params = {api_key: api_key, branch: options[:branch]}
        repo_name = encode_repo_key(repo_name)

        github_api.resource["/#{repo_name}"].post(params) do |response, request, result|
          results = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(results, "Can not find repository `#{repo_name}`")
        show_results(@@output_formats, results.data, options, nil)
        results
      end

    end
  end
end

