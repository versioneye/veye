require_relative '../base_executor.rb'

module Veye
  module Github
    class Delete < BaseExecutor

      def self.delete_repo(api_key, repo_name, options)
        github_api = API::Resource.new(RESOURCE_PATH)
        qparams = {
          :params => {
            :api_key => api_key,
            :branch => options[:branch]
          }
        }
        response_data = nil
        safe_repo_key = self.encode_repo_key(repo_name)
        github_api.resource["/#{safe_repo_key}"].delete(qparams) do |response, request, result|
          response_data = API::JSONResponse.new(request, result, response)
        end
        show_result(response_data)
        response_data
      end

      def self.show_result(response)
        unless response.success
          printf("Cant delete - %s\n%s\n", response.message.color(:red),
                                           response.data['error'])
        else
          printf "Deleted\n".color(:green)
        end
      end
    end
  end
end

