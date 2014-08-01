require_relative '../views/package.rb'
require_relative '../base_executor.rb'

module Veye
  module Package
    class References < BaseExecutor
      @@output_formats = {
        'csv'       => Package::ReferencesCSV.new,
        'json'      => Package::ReferencesJSON.new,
        'pretty'    => Package::ReferencesPretty.new,
        'table'     => Package::ReferencesTable.new
      }

      def self.validate_input!(lang, safe_prod_key)
        if lang.nil? or safe_prod_key.nil?
          msg =  %Q[
            You missed language or product key.
            Example: clojure/ztellman/aleph, which as required structure
            <prog lang>/<product_code>
          ]
          error_msg = sprintf("%s. \n%s",
                               "Error: Malformed key.".color(:red),
                               msg)
          exit_now!(error_msg)
        end
      end

      def self.get_references(package_key, options = {})
        product_api = API::Resource.new(RESOURCE_PATH)

        tokens = package_key.to_s.split('/')
        lang = Package.encode_language(tokens.first).capitalize #endpoint bug

        safe_prod_key = Package.encode_prod_key(tokens.drop(1).join("/"))
        validate_input!(lang, safe_prod_key)

        api_path = "/#{lang}/#{safe_prod_key}/references"
        page_nr = options[:page] || "1"
        qparams = {params: {page: page_nr}}
        results = nil

        product_api.resource[api_path].get(qparams) do |response, request, result, &block|
          results = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(results, "No references for: `#{package_key}`")
        show_results(@@output_formats, results.data, options, results.data['paging'])
        return results

      end
    end
  end
end

