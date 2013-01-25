 require 'terminal-table'

 module Veye
   module Project
     class ProjectListTable
       def before
         @@table = Terminal::Table.new :title => "Projects",
                   :headings => %w(index name project_key private period source dependencies outdated created_at)
         
         @@table.align_column(0, :right)
       end

       def after
         puts @@table.to_s
       end

       def format(results)
         results = [results] if results.is_a? Hash

         results.each_with_index do |result, index|
           row = [index + 1, result['name'], result['project_key'], result['private'],
                  result['period'], result['source'], result['dep_number'],
                  result['out_number'], result['created_at']]
           @@table << row
         end
       end
     end
   end
 end

