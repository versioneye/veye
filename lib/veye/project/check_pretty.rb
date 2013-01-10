require 'rainbow'

module Veye
  module Project
    class CheckPretty
      def before; end
      def after; end

      def format(results)
        results = [results] if results.is_a?(Hash)
        p results
        results.each_with_index do |result, index|
            project_name = "#{result['name']}".foreground(:green).bright
            printf("%3d - %s\n", index + 1, project_name)
            printf("\t%-15s: %s\n", "Product key", result["prod_key"])
            
            color = (result["outdated"] == true) ? :red : :green
            printf("\t%-15s: %s\n", "Outdated",
                                    "#{result["outdated"]}".foreground(color))

            printf("\t%-15s: %s\n", "Latest version",
                                    result["version_current"].foreground(color))
 
            printf("\t%-15s: %s\n", "Current version", result["version_requested"])
          
            dt_string = result["updated_at"]
            color = :default
            unless dt_string.nil?
                updated_at = DateTime.parse(dt_string) unless dt_string.nil?
                ago = DateTime.now - updated_at
                if ago < 7
                  color = :green
                elsif ago < 14
                  color = :yellow
                else
                  color = :red
                end
            end
            
            printf("\t%-15s: %s\n", "Updated",
                                    result["updated_at"].foreground(color))
           
        end
      end
    end
  end
end

