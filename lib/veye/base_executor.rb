require_relative 'helpers/format_helpers'

# Base class that will bring many helpers into command classes.
class BaseExecutor
  extend FormatHelpers

  def self.show_results(output_formats, results, options = {}, paging = nil)
    formatter = get_formatter(output_formats, options)
    return if formatter.nil?

    formatter.before
    formatter.format(results)
    formatter.after(paging, options[:pagination])
  end

  def self.valid_response?(response, msg)
    if response.nil? || response.success != true
      printf "#{msg.to_s.color(:red)}: #{response.data}\n"
      return false
    end

    response.success
  end

  # OBSOLETE: use valid_response?
  def self.catch_request_error(response, msg)
    valid_response?(response, msg)
  end

  def self.filter_dependencies(results, options)

    if options[:all]
      results['dependencies'].to_a.sort_by {|x| x['outdated'] ? -1 : 0}
    else
      results['dependencies'].to_a.keep_if {|x| x['outdated']}
    end
  end
  
  def self.show_dependencies(output_formats, results, options)
    formatter = get_formatter(output_formats, options)
    return if formatter.nil?

    deps = filter_dependencies(results, options)     

    formatter.before
    formatter.format deps
    formatter.after
  end

  def self.show_bulk_dependencies(output_formats, results, options)
    formatter = get_formatter(output_formats, options)
    return if formatter.nil?

    formatter.before
    results.each do |filename, deps|
      formatter.format filter_dependencies(deps, options), filename
    end

    formatter.after
  end

  def self.show_message(results, success_msg, fail_msg)
    if results.success
      printf "#{success_msg}\n".color(:green)
    else
      printf("Error: %s\n%s\n",
             fail_msg.color(:red),
             response.data['error'])
    end
  end

  def self.get_formatter(output_formats, options)
    format = options[:format]
    format ||= 'pretty'
    #return if format == 'json' #dependecy json format is handled by results formatter
    output_formats[format] if supported_format?(output_formats, format)
  end


end
