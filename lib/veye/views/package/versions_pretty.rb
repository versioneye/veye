require_relative '../base_pretty.rb'

module Veye
  module Package
    class VersionsPretty < BasePretty
      def format(result, n = 10, from = 0)
        return if result.nil?

        printf("\t%15s - %s\n", result['name'].to_s.color(:green).bright, result['version'].to_s.bright)
        printf("\t%-15s: %s\n", 'Language', result['language'])
        printf("\t%-15s: %s\n", 'Product type', result['prod_type'])
        printf("\t%-15s: %s\n", 'Product key', result['prod_key'])

        printf("\t%-15s: %d after skipping %d items\n", 'Showing items', n, from)


        result['versions'].to_a.each_with_index do |ver, i|
          printf("\t%-15s: %s\t%s\n", ver['version'], (from + i + 1), ver['released_at'])
        end
      end
    end
  end
end
