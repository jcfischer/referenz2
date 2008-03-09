#
# Configuration for building a war file
# By Robert Egglestone
#    Fausto Lelli
#
require 'util'

module War


  class Configuration
    include Singleton

    # the name of the project
    attr_accessor :name
    # the path and name of the war_file
    attr_accessor :war_file
    # path to the staging directory
    attr_accessor :staging
    # a list of patterns of excluded files
    attr_accessor :excludes
    # project java libraries are stored here
    attr_accessor :local_java_lib
    # servlet to use for running Rails
    attr_accessor :servlet
    # enable jndi support?
    attr_accessor :datasource_jndi
    attr_accessor :datasource_jndi_name

    # external locations
    attr_accessor :jruby_home
    attr_accessor :maven_local_repository
    attr_accessor :maven_remote_repository

    # compile ruby files? currently only preparses files, but has problems with paths
    attr_accessor :compile_ruby
    # keep source if compiling ruby files?
    attr_accessor :keep_source
    # if you set this to false gems will fail to load if their dependencies aren't available
    attr_accessor :add_gem_dependencies
    # standalone?
    attr_accessor :standalone
    # rails environment?
    attr_accessor :rails_env
    # rails environment to use when running with an embedded server?
    attr_accessor :rails_env_embedded

    # files to include in the package
    attr_accessor :files
    # java libraries to include in the package
    attr_accessor :java_libraries
    # gem libraries to include in the package
    attr_accessor :gem_libraries
    # jetty libraries, used for running the war
    attr_accessor :jetty_libraries

    # the real separator for the operating system
    attr_accessor :os_separator
    attr_accessor :os_path_separator
    
    attr_accessor :jetty_port
    attr_accessor :jetty_java_opts

    def initialize

      WLog.debug("initializing configuration ...")
      # default internal locations
      @staging = RAILS_ROOT
      @excludes = []
      @local_java_lib = File.join('lib', 'java')

      # default build properties
      @compile_ruby = false
      @keep_source =  false
      @add_gem_dependencies = true
      @servlet = 'org.jruby.webapp.RailsServlet'
      @rails_env = 'production'
      @rails_env_embedded = ENV['RAILS_ENV'] || 'development'
      @datasource_jndi = false

      home = ENV['HOME'] || ENV['USERPROFILE']
      @jruby_home = ENV['JRUBY_HOME']
      @maven_local_repository = ENV['MAVEN2_REPO'] # should be in settings.xml, but I need an override
      @maven_local_repository ||= File.join(home, '.m2', 'repository') if home
      @maven_remote_repository = 'http://www.ibiblio.org/maven2'

      # configured war name, defaults to the same as the ruby webapp
      @name = File.basename(File.expand_path(RAILS_ROOT))
      @war_file = "#{@name}.war"

      @files = {}
      
      @java_libraries = {}
      # default java libraries
      add_library(maven_library('org.jruby', 'jruby-complete', '1.1b1'))
      add_library(maven_library('org.jruby.extras', 'goldspike', '1.3'))
      add_library(maven_library('javax.activation', 'activation', '1.1'))
      add_library(maven_library('commons-pool', 'commons-pool', '1.3'))
      add_library(maven_library('bouncycastle', 'bcprov-jdk15', '136'))

      # default gems
      @gem_libraries = {}
      add_gem('rails', rails_version) unless File.exists?('vendor/rails')
      add_gem('ActiveRecord-JDBC') if Dir['vendor/{gems/,}{activerecord-jdbc,ActiveRecord-JDBC}'].empty?
      # add_gem('jruby-openssl')

      # default jetty libraries
      @jetty_libraries = {}
      add_jetty_library(maven_library('org.mortbay.jetty', 'start', '6.1.1'))
      add_jetty_library(maven_library('org.mortbay.jetty', 'jetty', '6.1.1'))
      add_jetty_library(maven_library('org.mortbay.jetty', 'jetty-util', '6.1.1'))
      add_jetty_library(maven_library('org.mortbay.jetty', 'servlet-api-2.5', '6.1.1'))
      add_jetty_library(maven_library('org.mortbay.jetty', 'jetty-plus', '6.1.1'))
      add_jetty_library(maven_library('org.mortbay.jetty', 'jetty-naming', '6.1.1'))
      
      # default jetty settings
      @jetty_port = 8080
      @jetty_java_opts = ENV['JAVA_OPTS'] || ''
      
      # separators
      if RUBY_PLATFORM =~ /(mswin)|(cygwin)/i # watch out for darwin
        @os_separator = '\\'
        @os_path_separator = ';'
      elsif RUBY_PLATFORM =~ /java/i
        @os_separator = java.io.File.separator
        @os_path_separator = java.io.File.pathSeparator
      else
        @os_separator = File::SEPARATOR
        @os_path_separator = File::PATH_SEPARATOR
      end

      # load user configuration
      WLog.debug("loading user configuration ...")
      load_user_configuration
    end # initialize
    
    def exclude_files(pattern)
      @excludes << pattern
    end

    def datasource_jndi_name
      @datasource_jndi_name || "jdbc/#{name}"
    end

    # Get the rails version from environment.rb, or default to the latest version
    # This can be overriden by using add_gem 'rails', ...
    def rails_version
      environment_without_comments = IO.readlines(File.join('config', 'environment.rb')).reject { |l| l =~ /^#/ }.join
      environment_without_comments =~ /[^#]RAILS_GEM_VERSION = '([\d.]+)'/
      version = $1
      version ? "= #{version}" : nil
    end

    def load_user_configuration
      user_config = ENV['WAR_CONFIG'] || File.join(RAILS_ROOT, 'config', 'war.rb')
      if File.exists?(user_config)
        begin
          War::Configuration::DSL.evaluate(user_config, self)
        rescue => e
          puts e.backtrace.join("\n")
                WLog.error("Error reading user configuration (#{e.message}), using defaults")
        end
      end
    end

    def java_library(name, version)
      WLog.debug("add java library : " + name + " " + version)
      # check local sources first, then the list
      JavaLibrary.new(name, version, self)
    end

    def maven_library(group, name, version)
      WLog.debug("add maven library : " + group + " " + name + " " + version)
      #locations = maven_locations(group, name, version)
      MavenLibrary.new(group, name, version, self)
    end

    def add_library(lib)
      @java_libraries[lib.name] = lib
    end

    def add_file(name, info)
      @files[name] = {:location => "war/#{name}", :directory => :classes }.merge(info)
    end
    
    def add_jetty_library(lib)
      @jetty_libraries[lib.name] = lib
    end

    def add_gem(name, match_version=nil)
      @gem_libraries[name] = match_version
    end

    def remove_gem(name)
      @gem_libraries.delete(name)
    end

 
    # This class is responsable for loading the war.rb dsl and parsing it to
    # evaluated War::Configuration
    # <note>will need to readjust this package impl </note>
    class DSL

      # saves internally the parsed result
      attr_accessor :result

      def initialize (configuration)
        @result = configuration
      end

      # method hook for name property
      def war_file(*val)
        WLog.warn "property 'war_file' takes only one argument" if val.size > 1
        @result.war_file = val[0]
      end
      
      def exclude_files(*val)
        WLog.warn "property 'exclude_files' takes only one argument" if val.size > 1
        @result.exclude_files(val[0])
      end

      def servlet(*val)
        WLog.warn "property 'servlet' takes only one argument" if val.size > 1
        @result.servlet = val[0]
      end

      def compile_ruby(*val)
        WLog.warn "property 'compile_ruby' takes only one argument" if val.size > 1
        unless is_either_true_or_false?(val[0])
          WLog.warn "property 'compile_ruby' must be either true or false"
          return
        end
        @result.compile_ruby = val[0]
      end

      def add_gem_dependencies(*val)
        WLog.warn "property 'add_gem_dependencies' takes only one argument" if val.size > 1
        unless is_either_true_or_false?(val[0])
          WLog.warn "property 'add_gem_dependencies' must be either true or false"
          return
        end
        @result.add_gem_dependencies = val[0]
      end

      def keep_source(*val)
        WLog.warn "property 'keep_source' takes only one argument" if val.size > 1
        unless is_either_true_or_false?(val[0])
          WLog.warn "property 'keep_source' must be either true or false"
          return
        end
        @result.keep_source = val[0]
      end
      
      def add_file(name, config={})
        @result.add_file(name, config)
      end

      def add_gem(*val)
        WLog.warn "add_gem takes at most two arguments" if val.size > 2
        @result.add_gem(val[0], val[1])
      end

      def datasource_jndi(*val)
        WLog.warn "property 'datasource_jndi' takes only one argument" if val.size > 1
        unless is_either_true_or_false?(val[0])
          WLog.warn "property 'datasource_jndi' must be either true or false"
          return
        end
        @result.datasource_jndi = val[0]
      end

      def datasource_jndi_name(*val)
        WLog.warn "datasource_jndi_name takes at most one argument" if val.size > 1
        @result.datasource_jndi_name = val[0]
      end

      def staging(*val)
          puts "Warning: staging takes only one argument" if val.size > 1
          @result.staging = val[0]
      end

      # method hook for library property
      def include_library(name, version)
        begin
          @result.add_library(@result.java_library(name, version))
        rescue
          WLog.warn "couldn't load library #{name}-#{version}.jar, check library definition in the config file"
          WLog.debug $!
        end
      end

      # method hook for maven library property
      def maven_library(group, name, version)
        begin
          @result.add_library(@result.maven_library(group, name, version))
        rescue
          WLog.warn "couldn't load maven library #{name}, check library definition in the config file"
          WLog.debug $!
        end
      end

      # method hook for default behaviour when an unknown property
      # is met in the dsl. By now, just ignore it and print a warning
      # message
      def method_missing(name, *args)
        WLog.warn "property '#{name}' in config file not defined, ignoring it ..."
      end

      # main parsing method. pass the file name for the dsl and the configuration
      # reference to evaluate against.
      def self.evaluate(filename, configuration)
        raise "file #{filename} not found " unless File.exists?(filename)
        dsl = new(configuration)
        dsl.instance_eval(File.read(filename) , filename)
        dsl
      end

      # utility
      def is_either_true_or_false?(obj)
        obj.class == TrueClass or obj.class == FalseClass
      end
    end #class DSL

  end #class
end #module
