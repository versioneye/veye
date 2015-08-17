module Veye
  module API
    module Github
      RESOURCE_PATH = "/github"
      def self.encode_repo_key(repo_key)
        repo_key.to_s.gsub(/\//, ":").gsub(/\./, "~")
      end


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

        github_api = Resource.new(RESOURCE_PATH)
        qparams = { :params => params }
        github_api.resource.get(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.import_all(api_key, force = false)
        params = {api_key: api_key}
        params[:force] = force || false
        qparams = {params: params}
        github_api = Resource.new(RESOURCE_PATH)

        github_api.resource['/sync'].get(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.get_repo(api_key, repo_name, branch = nil, file = nil)
        safe_repo_name = self.encode_repo_key(repo_name)
        github_api = Resource.new("#{RESOURCE_PATH}/#{safe_repo_name}")
        qparams = {api_key: api_key}
        qparams[:branch] = branch unless branch.nil?
        qparams[:file] = file unless file.nil?

        github_api.resource.get({params: qparams}) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

    end
  end
end
