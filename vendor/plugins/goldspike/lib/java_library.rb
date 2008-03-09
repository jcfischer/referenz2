#
# A library which can hopefully be obtained through one of the following mechanisms:
# + A local artifact: lib/java/jruby-0.9.1.jar
# + An artifact in a local maven repo: ~/.m2/repository/org/jruby/jruby/0.9.1/jruby-0.9.1/jar
# + An artifact in a remote maven repo: http://www.ibiblio.com/maven2/org/jruby/jruby/0.9.1/jruby-0.9.1/jar
#
require 'util'

module War
  class JavaLibrary
    
    attr_accessor :name, :version, :locations, :config
    
    def initialize(name, version, config)
      @config = config
      @name = name
      @version = version
      @locations = local_locations(name, version)
    end
    
    def file
      "#{name}-#{version}.jar"
    end
    
    def install(config, target_file)
      found = false
      for location in locations
        if location[0,5] == 'http:' || location[0,6] == 'https:'
          found = install_remote(config, location, target_file)
        else
          found = install_local(config, location, target_file)
        end
        break if found
      end
      
      unless found
        # all attempts have failed, inform the user
        raise <<-ERROR
        The library #{self} could not be obtained from in any of the following locations:
          + #{locations.join("
        + ")}
        ERROR
      end
    end
    
    def install_local(config, file, target_file)
      return false unless File.exists?(file)
      File.install(file, target_file, 0644)
      return true
    end
    
    def install_remote(config, location, target_file)
      response = read_url(location)
      return false unless response
      File.open(target_file, 'wb') { |out| out << response.body }
      return true
    end
    
    # properly download the required files, taking account of redirects
    # this code is almost straight from the Net::HTTP docs
    def read_url(uri_str, limit=10)
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0
      require 'net/http'
      require 'uri'
      # setup the proxy if available
      http = Net::HTTP
      if ENV['http_proxy']
        proxy = URI.parse(ENV['http_proxy'])
        http = Net::HTTP::Proxy(proxy.host, proxy.port, proxy.user, proxy.password)
      end
      # download the file
      response = http.get_response(URI.parse(uri_str))
      case response
      when Net::HTTPSuccess then response
      when Net::HTTPRedirection then read_url(response['location'], limit - 1)
      else false
      end
    end
    
    def to_s
      "#{name}-#{version}"
    end
        
    def local_locations(name, version, type='jar')
      WLog.debug("locations for " + name + " " + version);
      paths = []
      if config.local_java_lib
        paths << File.join(config.local_java_lib, "#{name}-#{version}.#{type}")
        paths << File.join(config.local_java_lib, "#{name}.#{type}")
      end
      if config.jruby_home
        paths << File.join(config.jruby_home, 'lib', "#{name}-#{version}.#{type}")
        paths << File.join(config.jruby_home, 'lib', "#{name}.#{type}")
      end
      WLog.debug("paths: " + paths.join("\n"))
      return paths
    end

  end #class

  class MavenLibrary < JavaLibrary

    attr_accessor :group, :name, :version, :config

    def initialize (group, name, version, config)
      @config = config
      @group = group
      @name = name
      @version = version
      @locations = maven_locations(group, name, version)   
    end
	
    def maven_locations(group, artifact, version, type='jar')
      WLog.debug("locations for " + group + " " + artifact + " " + version);
      paths = []
      maven_local_repository = config.maven_local_repository
      maven_remote_repository = config.maven_remote_repository
      if maven_local_repository
        paths << File.join(maven_local_repository, group.gsub('.', File::SEPARATOR), artifact, version, "#{artifact}-#{version}.#{type}")
      end
      if maven_remote_repository
        paths << "#{maven_remote_repository}/#{group.gsub('.', '/')}/#{artifact}/#{version}/#{artifact}-#{version}.#{type}"
      end
      WLog.debug("paths: " + paths.join("\n"))
      return paths
    end

  end


end #module