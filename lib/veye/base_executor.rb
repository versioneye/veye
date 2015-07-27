class BaseExecutor
  extend FormatHelpers
  extend RepoHelpers

  def self.show_results(output_formats, results, options = {}, paging = nil)

    format = options[:format] || 'pretty'
    self.supported_format?(output_formats, format)
    formatter = output_formats[format]

    formatter.before
    formatter.format(results)
    formatter.after(paging, options[:pagination])
  end

  def self.valid_response?(response, msg)
    if response.nil? or response.success != true
      p "#{msg.to_s.color(:red)}: #{response.data.to_s}\n"
      return false
    end

    return true
  end

  #OBSOLETE: use valid_response?
  def self.catch_request_error(response, msg)
    valid_response?(response, msg)
  end
end
