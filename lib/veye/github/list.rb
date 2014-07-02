require_relative '../views/github.rb'
require_relative '../base_executor.rb'

module Veye
  module Github
    class List < BaseExecutor

      @@output_formats = {
        'csv'     => Github::ListCSV.new,
        'json'    => Github::ListJSON.new,
        'pretty'  => Github::ListPretty.new,
        'table'   => Github::ListTable.new
      }

      def self.get_list(api_key, options)
        github_api = API::Resource.new(RESOURCE_PATH)
        results = nil
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
          results = API::JSONResponse.new(request, result, response)
        end
        catch_request_error(results, "No repositories.")
        show_results @@output_formats, results.data, options, results.data['paging']
      end
    end
  end
end

