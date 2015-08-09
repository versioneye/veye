require_relative '../views/github.rb'
require_relative '../base_executor.rb'

module Veye
  module Github
    module API
      def self.encode_repo_key(repo_key)
        repo_key.to_s.gsub(/\//, ":").gsub(/\./, "~")
      end
 
      def self.get_repo(api_key, repo_name)
        safe_repo_name = self.encode_repo_key(repo_name)
        github_api = Veye::API::Resource.new("#{RESOURCE_PATH}/#{safe_repo_name}")
        qparams = {params: {api_key: api_key}}

        github_api.resource.get(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end
    end

    class Info < BaseExecutor
      @@output_formats = {
        'csv'     => Github::InfoCSV.new,
        'json'    => Github::InfoJSON.new,
        'pretty'  => Github::InfoPretty.new,
        'table'   => Github::InfoTable.new
      }

      def self.get_repo(api_key, repo_name, options)
        results = API.get_repo(api_key, repo_name)
        catch_request_error(results, "Can not find repository `#{repo_name}`")
        show_results @@output_formats, results.data, options
      end
    end
  end
end

