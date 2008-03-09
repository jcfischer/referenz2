class GoldspikeGenerator < Rails::Generator::Base
  
  def initialize(runtime_args, runtime_options = {})
    super
  end
    
  def manifest
    record do |m|
      m.directory 'config'
      m.template 'war.rb', File.join('config', 'war.rb')
      m.directory 'WEB-INF'
      m.template 'web.xml.erb', File.join('WEB-INF', 'web.xml.erb')
    end
  end
  
  protected
  
  def banner
    "Usage: #{$0} goldspike"
  end  
end