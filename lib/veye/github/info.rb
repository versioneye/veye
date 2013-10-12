require_relative '../views/github.rb'
require_relative '../base_executor.rb'

module Veye
  module Github
    class Info < BaseExecutor
      @@output_formats = {
        'csv'     => Github::InfoCSV.new,
        'json'    => Github::InfoJSON.new,
        'pretty'  => Github::InfoPretty.new,
        'table'   => Github::InfoTable.new
      }

      def self.get_repo(api_key, repo_name, options)
        github_api = API::Resource.new(RESOURCE_PATH)
        results = nil
        qparams = {params: {api_key: api_key}}
        safe_repo_name = self.encode_repo_key(repo_name)

        github_api.resource["/#{safe_repo_name}"].get(qparams) do |response, request, result|
          results = API::JSONResponse.new(request, result, response)
        end
        catch_request_error(results, "Can not find repository `#{repo_name}`")
        show_results @@output_formats, results.data, options
      end

    end
  end
end

