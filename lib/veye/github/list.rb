require_relative 'github_list_csv.rb'
require_relative 'github_list_json.rb'
require_relative 'github_list_pretty.rb'
require_relative 'github_list_table.rb'


module Veye
  module Github
    class List
      extend FormatHelpers

      @@output_formats = {
        'csv'     => GithubListCSV.new,
        'json'    => GithubListJSON.new,
        'pretty'  => GithubListPretty.new,
        'table'   => GithubListTable.new
      }

      def self.get_list(api_key, options)
        github_api = API::Resource.new(RESOURCE_PATH)
        response_data = nil
        params = {api_key: api_key}
        params[:page]     = options[:page] || 1
        params[:lang]     = options[:lang].to_s.downcase if options[:lang]
        unless options[:private].nil?
         params[:private]  = (options[:private] == 'true') || (options[:private] == 't') 
        end      
        params[:org_name] = options[:org] if options[:org]
        params[:org_type] = options['org-type'] if options['org-type']

        qparams = { :params => params }
        github_api.resource.get(qparams) do |response, request, result|
          response_data = API::JSONResponse.new(request, result, response)
        end

        return response_data
      end
      
      def self.format(results, format = 'pretty', paging = nil)
          self.supported_format?(@@output_formats, format)  

          formatter = @@output_formats[format]
          formatter.before
          formatter.format results
          formatter.after paging
      end
    end
  end
end

