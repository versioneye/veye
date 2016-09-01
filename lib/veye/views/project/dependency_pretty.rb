require_relative '../base_pretty.rb'

module Veye
  module Project
    class DependencyPretty < BasePretty
      def format(results, filename = nil)
        return if results.nil?
        results = [results] if results.is_a?(Hash)

        printf("#-- Dependencies #{filename.to_s}-----------------------------------------\n")
        results.each_with_index do |result, index|
          project_name = "#{result['name']}".color(:green).bright
          printf("%3d - %s\n", index + 1, project_name)
          #shows project file names
          if filename
            printf("\t%-15s: %s\n", "Sourcefile", filename)
          end

          printf("\t%-15s: %s\n", "Product key", result["prod_key"])

          color_code = (result["outdated"] == true) ? :red : :green
          printf("\t%-15s: %s\n",
                 "Outdated",
                 "#{result['outdated']}".color(color_code))

          printf("\t%-15s: %s\n", "Current", "#{result['version_current']}".color(color_code))

          printf("\t%-15s: %s\n", "Requested", result["version_requested"])
          
          licenses = result["licenses"].to_a.map {|x| x['name']}
          printf("\t%-15s: %s\n", "Licenses", licenses.join(', '))

          if result.has_key?(:upgrade)
            printf(
              "\t%-15s: %s(%.2f)\n",
              "Upgrade cost",
              result[:upgrade][:difficulty],
              result[:upgrade][:dv_score]
            )
          end


        end
      end
    end
  end
end

