require 'rainbow/ext/string'

module FormatHelpers
  def supported_format?(output_formats, format)
    if output_formats.nil?
      exit_now! "Executor doesnt have any formattor defined."
    end
    unless output_formats.has_key?(format)
      msg = "This command doesnt support output format: `#{format}`\n".color(:red)
      msg += "Supported formats: #{output_formats.keys.join(', ')}\n"
      exit_now! msg
    end
    true
  end

end
