require_relative '../views/github.rb'
require_relative '../base_executor.rb'

module Veye
  module Github
    module API
      def self.get_list(api_key, page = 1, lang = nil, privat = nil, org = nil, type = nil)
        params = {
          api_key: api_key,
          page: page || 1
        }
        params[:lang]     = lang.to_s.downcase if lang
        unless private.nil?
         params[:private]  = privat == 'true' || privat == 't' || privat == true
        end
        params[:org_name] = org if org
        params[:org_type] = type if type

        github_api = Veye::API::Resource.new(RESOURCE_PATH)
        qparams = { :params => params }
        github_api.resource.get(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end 
      end
    end

    class List < BaseExecutor

      @@output_formats = {
        'csv'     => Github::ListCSV.new,
        'json'    => Github::ListJSON.new,
        'pretty'  => Github::ListPretty.new,
        'table'   => Github::ListTable.new
      }

      def self.get_list(api_key, options)
        results = Veye::Github::API.get_list(api_key, options[:page], options[:lang],
                                            options[:private], options[:org],
                                            options[:org_type])
        if valid_response?(results, "No repositories.")
          show_results(@@output_formats, results.data, options, results.data['paging'])
        end
      end
    end
  end
end

