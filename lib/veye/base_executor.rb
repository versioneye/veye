require_relative 'helpers/format_helpers'

# Base class that will bring many helpers into command classes.
class BaseExecutor
  extend FormatHelpers

  def self.show_results(output_formats, results, options = {}, paging = nil)
    formatter = get_formatter(output_formats, options)
    return if formatter.nil?

    formatter.before

    #if command uses s.o windowed output aka show only part of the items list
    if options.has_key?(:n) or options.has_key?(:from)
      formatter.format(results, options[:n].to_i, options[:from].to_i)
    else
      formatter.format(results)
    end
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

  def self.show_dependencies(output_formats, proj_deps, options)
    formatter = get_formatter(output_formats, options)
    return if formatter.nil?

    sorted_deps = process_dependencies(proj_deps.to_a, options)
    
    formatter.before
    formatter.format sorted_deps.to_a
    formatter.after
  end

  def self.show_bulk_dependencies(output_formats, results, options)
    formatter = get_formatter(output_formats, options)
    return if formatter.nil?

    formatter.before
    results.each do |filename, project|
      sorted_deps = process_dependencies(project['dependencies'].to_a, options)

      formatter.format(sorted_deps.to_a, filename)
    end

    formatter.after
  end
  
  def self.sort_dependencies_by_upgrade_complexity(deps)
    deps.to_a.sort {|a, b| b[:upgrade][:dv_score] <=> a[:upgrade][:dv_score]}
  end

  def self.filter_dependencies(deps, options = {})
    return deps if ( options[:all] == true )

    deps.keep_if {|d| d['outdated'] == true}
 
    #if any of filter flags are not selected then return only outdated deps

    if (options[:major] or options[:minor] or options[:patch]) == false
      return deps
    end

    filtered_deps = []
    if options.fetch(:major, false) == true
      deps.each {|d| filtered_deps << d if d[:upgrade][:dv_major] > 0}
    end

    if options.fetch(:minor, false) == true
      deps.each do |d|
        if d[:upgrade][:dv_minor] > 0 and d[:upgrade][:dv_major] == 0
          filtered_deps << d
        end
      end
    end

    if options.fetch(:patch, false)  == true
      deps.each do |d|
        if d[:upgrade][:dv_patch] > 0 and d[:upgrade][:dv_minor] == 0 and d[:upgrade][:dv_major] == 0
          filtered_deps << d
        end
      end
    end

    #remove duplicates if user attached multiple filter flags
    already_seen_keys = Set.new
    filtered_deps.reduce([]) do |acc, dep|
      unless already_seen_keys.include?(dep['prod_key'])
        acc << dep
        already_seen_keys << dep['prod_key']
      end

      acc
    end
  end

  def self.process_dependencies(proj_deps, options)
    proj_deps.to_a.map do |dep|
      dep[:upgrade] = Veye::Project.calc_upgrade_heuristics(dep['version_requested'], dep['version_current'])
      dep
    end
  
    proj_deps = filter_dependencies(proj_deps, options)
    proj_deps = sort_dependencies_by_upgrade_complexity(proj_deps)

    proj_deps.to_a
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
