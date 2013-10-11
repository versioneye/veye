require_relative 'github_search_csv.rb'
require_relative 'github_search_json.rb'
require_relative 'github_search_pretty.rb'
require_relative 'github_search_table.rb'

module Veye
  module Github
    class Search
      extend FormatHelpers

      @@output_formats = {
        'csv'     => GithubSearchCSV.new,
        'json'    => GithubSearchJSON.new,
        'pretty'  => GithubSearchPretty.new,
        'table'   => GithubSearchTable.new
      }

      def self.search(api_key, search_term, options)
        github_api = API::Resource.new(RESOURCE_PATH)
        response_data = nil
        params = {api_key: api_key, q: search_term}
        params[:langs] = options[:lang] unless options[:lang].nil?
        params[:users] = options[:user] unless options[:user].nil?
        params[:page]  = options[:page] || "1" 
        qparams = {params: params}
        
        github_api.resource["/search"].get(qparams) do |response, request, result|
          response_data = API::JSONResponse.new(request, result, response)
        end

        return response_data
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

