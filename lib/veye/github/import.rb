require_relative '../views/github.rb'
require_relative '../base_executor.rb'

module Veye
  module Github
    module API
      def self.import_repo(api_key, repo_name, branch = nil, filename = nil)
        safe_repo_name = encode_repo_key(repo_name)
        github_api = Veye::API::Resource.new("#{RESOURCE_PATH}/#{safe_repo_name}")

        params = {api_key: api_key}
        params[:branch] = branch unless branch.nil?
        params[:file] = filename unless filename.nil?
        
        github_api.resource.post(params) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end
    end

    class Import < BaseExecutor
      @@output_formats = {
        'csv'     => Github::InfoCSV.new,
        'json'    => Github::InfoJSON.new,
        'pretty'  => Github::InfoPretty.new,
        'table'   => Github::InfoTable.new
      }

      def self.import_repo(api_key, repo_name, options)
        results = API.import_repo(api_key, repo_name, options[:branch], options[:file])
        catch_request_error(results, "Can not find repository `#{repo_name}`")
        show_results(@@output_formats, results.data, options, nil)
      end
    end
  end
end

