module Veye
  module Project

    RESOURCE_PATH = "/projects"
    MAX_FILE_SIZE = 500000 #byte ~ 500kb
    class Check
       
      def self.upload(filename)
        file_path = File.absolute_path(filename)
        puts "I'm currently: #{Dir.pwd}"
        puts "Reading file: #{file_path}"
         
        unless File.exists?(file_path)
            error_msg = sprintf("%s: Cant read file `%s`", 
                                "Error".foreground(:red),
                                "#{filename}".foreground(:yellow)
                               )
            exit_now!(error_msg)
        end

        file_size = File.size(file_path)
        unless file_size != 0 and file_size < MAX_FILE_SIZE
            exit_now!("Size of file is not acceptable: 0kb < x <= #{MAX_FILE_SIZE/1000}kb")
        end
       
        project_api = Veye::API::Resource.new(RESOURCE_PATH)
        file_obj = File.open(file_path, 'rb')
        puts "Making request:"
        project_api.resource.post({:upload => file_obj}) do |response, request, result, &block|
            puts result.code
            puts response
            puts request
        end
        
        file_obj.close
        return response
      end

      def self.analyze(filename)
        project_api = Veye::API::Resource.new RESOURCE_PATH
        exit_now!("Not implemented.")
      end

      def self.delete(project_id)
        project_api = Veye::API::Resource.new(RESOURCE_PATH)
        exit_now!("Not implemented.")
        #project_api.delete {:id => project_id}
      end

      def self.format(result, format = 'pretty')
        puts "To do..."
      end
    end
  end
end

