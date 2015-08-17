module Veye
  module API
    module Github
      RESOURCE_PATH = "/github"

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

    end
  end
end
