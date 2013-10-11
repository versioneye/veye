require_relative 'github_info_csv.rb'
require_relative 'github_info_json.rb'
require_relative 'github_info_pretty.rb'
require_relative 'github_info_table.rb'

module Veye
  module Github
    class Info
      extend FormatHelpers

      @@output_formats = {
        'csv'     => GithubInfoCSV.new,
        'json'    => GithubInfoJSON.new,
        'pretty'  => GithubInfoPretty.new,
        'table'   => GithubInfoTable.new
      }
      
      def self.encode_repo_key(repo_key)
        repo_key.to_s.gsub(/\//, ":").gsub(/\./, "~")
      end


      def self.get_repo(api_key, repo_name, options)
        github_api = API::Resource.new(RESOURCE_PATH)
        response_data = nil
        qparams = {params: {api_key: api_key}}
        repo_name = encode_repo_key(repo_name)
        github_api.resource["/#{repo_name}"].get(qparams) do |response, request, result|
          response_data = API::JSONResponse.new(request, result, response)
        end
      end

      def self.format(search_results, format = 'pretty', paging = nil)
          self.supported_format?(@@output_formats, format)  

          formatter = @@output_formats[format]
          formatter.before
          formatter.format(search_results)
          formatter.after paging
      end

    end
  end
end

