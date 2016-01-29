require 'logger'
module Functionalism
  VERBOSITY = Logger::INFO

  def logger
    @logger = build_logger(VERBOSITY)
  end

  private
  def build_logger(level)
    warning_log = Logger.new(STDOUT)
    warning_log.level = level
    warning_log
  end
end
