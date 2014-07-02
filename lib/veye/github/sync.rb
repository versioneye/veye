require_relative '../base_executor.rb'

module Veye
  module Github
    class Sync < BaseExecutor
      def self.import_all(api_key, options)
        github_api = API::Resource.new(RESOURCE_PATH)
        response_data = nil
        params = {api_key: api_key}
        params[:force] = options[:force] unless options[:force].nil?

        qparams = {params: params}
        github_api.resource['/sync'].get(qparams) do |response, request, result|
          response_data = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(response_data, "Can not import repositories from Github")
        show_result(response_data)
        return response_data
      end

      def self.show_result(response)
        unless response.data["changed"]
          printf("%s - %s\n",
                 "No changes.".color(:red),
                 "Use `force` flag if you want to reload everything.")
        else
          printf "Imported. #{response.data['msg']}\n".color(:green)
        end
      end
    end
  end
end
