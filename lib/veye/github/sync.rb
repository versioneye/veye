require_relative '../base_executor.rb'

module Veye
  module Github
    module API
      def self.import_all(api_key, force = false)
        github_api = Veye::API::Resource.new(RESOURCE_PATH)
        params = {api_key: api_key}
        params[:force] = force || false

        qparams = {params: params}
        github_api.resource['/sync'].get(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end
    end

    class Sync < BaseExecutor
      def self.import_all(api_key, options)
        response = API.import_all(api_key, options[:force])
        catch_request_error(response, "Can not import repositories from Github")
        show_result(response)
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
