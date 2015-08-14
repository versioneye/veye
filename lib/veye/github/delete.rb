require_relative '../base_executor.rb'

module Veye
  module Github
    module API
      def self.delete_repo(api_key, repo_name, branch = nil)
        safe_repo_key = self.encode_repo_key(repo_name)
        github_api = Veye::API::Resource.new("#{RESOURCE_PATH}/#{safe_repo_key}")
        qparams = { :api_key => api_key }
        qparams[:branch] = branch unless branch.nil?

        github_api.resource.delete({params: qparams}) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end
    end

    class Delete < BaseExecutor

      def self.delete_repo(api_key, repo_name, options)
        response = Veye::Github::API.delete_repo(api_key, repo_name, options[:branch])
        show_result(response)
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

