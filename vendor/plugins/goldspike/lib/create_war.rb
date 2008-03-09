#
# Building a war file
#
# By Robert Egglestone
#    Fausto Lelli (*minor* patches for windows platform, plugin dist.)
#

require 'fileutils'
require 'java_library'
require 'war_config'
require 'packer'
require 'util'

module War
  class Creator

    attr_accessor :config

    def initialize(config = Configuration.instance)
      @config = config
      @java_lib_packer = JavaLibPacker.new(@config)
      @ruby_lib_packer = RubyLibPacker.new(@config)
      @webapp_packer = WebappPacker.new(@config)
      @file_packer = FileLibPacker.new(@config)
    end

    def standalone=(value)
      @config.standalone = value
    end

    def create_shared_war
      @config.standalone = false
      create_war_file
    end

    def create_standalone_war
      @config.standalone = true
      create_war_file
    end

    def clean_war
      FileUtils.remove_file(@config.war_file) if File.exists?(@config.war_file)
    end

    def create_war_file
      assemble
      create_war
    end

    def assemble
      WLog.info 'Assembling web application'
      add_java_libraries
      if config.standalone
        add_ruby_libraries
      end
      add_configuration_files
      add_files
    end

    private

    def create_war
      WLog.info 'Creating web archive'
      @webapp_packer.create_war
    end

    def add_files
      @file_packer.add_files
    end

    def add_java_libraries
      @java_lib_packer.add_java_libraries
    end

    def add_ruby_libraries
      @ruby_lib_packer.add_ruby_libraries
    end

    def add_configuration_files
      require 'erb'
      File.makedirs(File.join(config.staging, 'WEB-INF'))
      war_file_dir = File.join(config.staging, 'WEB-INF')
      Dir.foreach(war_file_dir) do |file|        
        output = case file
          when /\.\Z/ # ignore dotfiles
            nil
          when /\.erb\Z/
            output_file = file.gsub(/\.erb\Z/, '')
            template = File.read(File.join(war_file_dir, file))
            erb = ERB.new(template)
            erb.result(binding)
          end
    
        unless output.nil? 
          File.open(File.join(config.staging, 'WEB-INF', output_file), 'w') { |out| out << output}      
        end
        
      end
    end

  end #class
end #module
