module Veye
  #-- CLI wrappers for API
  class Service
    def self.ping(n = 1)
      show_result(Veye::API::Service.ping)
    end

    def self.show_result(result)
      if result.nil?
        puts "Request failure".color(:red)
      elsif result.success
        puts "#{result.data['message']}".color(:green)
      else
        printf(
          "VersionEye didnt recognized secret word.Answered %s, %s\n",
          result.code.to_s.color(:red),
          result.message.to_s.color(:yellow)
        )
      end
    end
  end
end
