module Veye
  module Github
    class Delete
      def self.encode_repo_key(repo_key)
        repo_key.to_s.gsub(/\//, ":").gsub(/\./, "~")
      end

      def self.delete_repo(api_key, repo_key, options)
        github_api = API::Resource.new(RESOURCE_PATH)
        qparams = {
          :params => {
            :api_key => api_key,
            :branch => options[:branch]
          }
        }
        response_data = nil

        github_api.resource["/#{project_key}"].delete(qparams) do |response, request, result|
          response_data = API::JSONResponse.new(request, result, response)
        end
        response_data
      end
    end
  end
end

