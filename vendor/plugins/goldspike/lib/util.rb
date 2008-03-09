require 'logger'

module War
  
  # A wrapper class for the 'logger' ruby lib 
  #   logging levels are (default: INFO)
  #   Logger::Severity::DEBUG
  #   Logger::Severity::INFO
  #   Logger::Severity::WARN
  #   Logger::Severity::FATAL
  #   Logger::Severity::UNKNOWN
  
  class WLog
    @@logger_inst = Logger.new(STDOUT)
    #@@logger_inst.level = Logger::Severity::DEBUG
    @@logger_inst.level = Logger::Severity::INFO
    
    def self.level=(level_req) 
      @@logger_inst.level = level_req
    end
  
    Logger::Severity.constants.each { |level| 
      level.downcase!
      instance_eval %{
          def #{level}(text='')
              @@logger_inst.send("#{level}","#{level}: " + text)
          end
      }
    }
  end
 
end

   
  
