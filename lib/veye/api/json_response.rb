require 'json'

module Veye
  module API
    class JSONResponse
      attr_reader :code, :success, :message, :data, :url, :headers
      def initialize(request, result, response)
         @url = request.url
         @headers = request.headers
         @code = result.code.to_i

         response_data = JSON.parse(response)

         @success, @message = success?(result, response_data)
         @data = response_data
      end

      def success?(result, response_data)
        @code = result.code.to_i
        success = false
         
        case @code 
        when 200
          success = true
          message = "fetched successfully"
        when 201
          success = true
          message = "created successfully"
        when 400
          message = "bad request - wrong parameters, data"
        when 401
          message = "not authorized - add apikey or update settings file ~/.veye.rc"
        when 403
          message = "forbidden - server refused execute query"
        when 413
          message = "request entity too big - use smaller data object"
        when 500
          message = "internal server error - write to us"
        when 501
          message = "not implemented - write to us"
        when 503
          message = "service unavailable - temporary overloaded - write to us."
        when 531
          message = "not authorized - add apikey or update settings file ~/.veye.rc"
        else
          success = false
          message = ""
        end

         return success, message
      end


    end
  end
end
