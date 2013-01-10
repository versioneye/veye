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

         @success = success?(result, response_data)
         @message = response_data["msg"]
         @data = response_data["data"]
      end

      def success?(result, response_data)
         success = false
         if @code == 200 and response_data.has_key?("success")
             case response_data["success"]
             when true, "true", 1, "1"
               success = true
             else
               success = false
             end
         end

         return success
      end


    end
  end
end
