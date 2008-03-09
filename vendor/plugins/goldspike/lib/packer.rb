
require 'util'

module War
  
  class Packer
  
    attr_accessor :config
  
    def initialize(config = Configuration.instance)
      @config = config
    end
    
    def install(source, dest, mode=0644)
      # File.install is disabled because of a performance problem under JRuby,
      # without it the task may fail if the original gem files were not writable by the owner
      #File.install(source, dest, mode)
      File.copy(source, dest)
    end
    
    def copy_tree(files, target, strip_prefix='')
      files.each do |f|
        relative = f[strip_prefix.length, f.length]
        target_file = File.join(target, relative)
        if File.directory?(f)
          File.makedirs(target_file)
        elsif File.file?(f)
          WLog.debug "  Copying #{f} to #{relative}"
          File.makedirs(File.dirname(target_file))
          install(f, target_file)
        end
      end    
    end
    
    def compile_tree(dir, config)
      return unless config.compile_ruby
      # find the libraries
      classpath_files = Rake::FileList.new(File.join(config.staging, 'WEB-INF', 'lib', '*.jar'))
      classpath_files_array = classpath_files.to_a
      classpath_files_array.collect! {|f| File.expand_path(f) }
      classpath = classpath_files_array.join(config.os_path_separator)
      # compile the files
      os_dir = dir.gsub(File::SEPARATOR, config.os_separator)
      unless system("cd #{os_dir} && java -cp #{classpath} org.jruby.webapp.ASTSerializerMain")
        raise "Error: failed to preparse files in #{dir}, returned with error code #{$?}"    
      end
    end
    
    def jar(target_file, source_dir, files, compress=true)
      os_target_file = target_file.gsub(File::SEPARATOR, config.os_separator)
      os_source_dir = source_dir.gsub(File::SEPARATOR, config.os_separator)
      flags = '-cf'
      flags += '0' unless compress
      files_list = files.join(' ')
      unless system("jar #{flags} #{os_target_file} -C #{os_source_dir} #{files_list}")
        raise "Error: failed to create archive, error code #{$?}"
      end
    end
    
  end
  
  class FileLibPacker < Packer
    def add_files
      WLog.info("Packing needed files ...")

      staging = config.staging
      lib = File.join(staging, 'WEB-INF', 'lib')
      classes = File.join(staging, 'WEB-INF', 'classes')
      base = File.join(staging, 'WEB-INF')
      install(:lib, lib)
      install(:classes, classes)
      install(:base, base)
    end

    def install(dir_sym, dir)
      WLog.debug("assembling files in " + dir + " directory")
      File.makedirs(dir)
      WLog.debug("need to assemble #{config.files.select{|k,v| v[:directory] == dir_sym }.size} files")
      for name, file_info in config.files
        next unless file_info[:directory] == dir_sym
        WLog.debug("file to add " + name )
        target = File.join(dir, name)
        WLog.debug("should install to " + target)
        file = file_info[:location]
        if !File.exists?(target) || File.mtime(target) < File.mtime(file_info[:location])
          WLog.info "  adding file #{name}"
          if File.exists?(file)
            File.install(file, target, 0644)
          else
            WLog.warn "file '#{file}' does not exist"
          end
        end
      end
    end
  end
    
  class JavaLibPacker < Packer
    
    def initialize(config)
      super(config)
    end
    
    def add_java_libraries
      WLog.info("Packing needed Java libraries ...")
      staging = config.staging
      lib = File.join(staging, 'WEB-INF', 'lib')
      WLog.debug("assembling files in " + lib + " directory")
      File.makedirs(lib)
      WLog.debug("need to assemble #{config.java_libraries.size} libraries")
      for library in config.java_libraries.values
        WLog.debug("library to assemble " + library.name )
        target = File.join(lib, library.file)
        WLog.debug("should install to " + target)
        unless File.exists?(target)
          WLog.info "  adding Java library #{library}"
          library.install(config, target)
        end
      end
    end
  end
  
  class RubyLibPacker < Packer

    def initialize (config)
      super(config)
    end
    
    def add_ruby_libraries
      # add the gems
      WLog.info("Packing needed Ruby gems ...")
      gem_home = File.join(config.staging, 'WEB-INF', 'gems')
      File.makedirs(gem_home)
      File.makedirs(File.join(gem_home, 'gems'))
      File.makedirs(File.join(gem_home, 'specifications'))
      for gem in config.gem_libraries
        copy_gem(gem[0], gem[1], gem_home)
      end
    end
    
    def copy_gem(name, match_version, target_gem_home)
      require 'rubygems'
      matched = Gem.source_index.search(name, match_version)
      raise "The #{name} gem is not installed" if matched.empty?
      gem = matched.last

      gem_target = File.join(target_gem_home, 'gems', gem.full_gem_path.split('/').last)

      unless File.exists?(gem_target)
        # package up the gem
        WLog.info "  adding Ruby gem #{gem.name} version #{gem.version}"
        # copy the specification
        install(gem.loaded_from, File.join(target_gem_home, 'specifications'), 0644)
        # copy the files
        File.makedirs(gem_target)
        gem_files = Rake::FileList.new(File.join(gem.full_gem_path, '**', '*'))
        copy_tree(gem_files, gem_target, gem.full_gem_path)
        # compile the .rb files to .rb.ast.ser
        compile_tree(File.join(gem_target, 'lib'), config)
      end
      
      # handle dependencies
      if config.add_gem_dependencies
        for gem_child in gem.dependencies
          #puts "  Gem #{gem.name} requires #{gem_child.name} "
          copy_gem(gem_child.name, gem_child.requirements_list, target_gem_home)
        end
      end
    end
    
  end
  
  class WebappPacker < Packer

    def initialize(config)
      super(config)
    end
    
    def create_war
      # we can't include a directory, but exclude it's files
      webapp_files = Rake::FileList.new
      webapp_files.include('*')
      webapp_files.exclude('*.war')
      webapp_files.exclude(/tmp$/)
      webapp_files.include(File.join('tmp', '*'))
      webapp_files.exclude(File.join('tmp', 'jetty'))
      config.excludes.each do |exclude|
        webapp_files.exclude(exclude)
      end

      jar(config.war_file, config.staging, webapp_files)
    end
    
    def add_webapp
      staging = config.staging
      WLog.info 'Packing web application ...'
      File.makedirs(staging)
      webapp_files = Rake::FileList.new(File.join('.', '**', '*'))
      webapp_files.exclude(staging)
      webapp_files.exclude('*.war')
      webapp_files.exclude(config.local_java_lib)
      webapp_files.exclude(File.join('public', '.ht*'))
      webapp_files.exclude(File.join('public', 'dispatch*'))
      webapp_files.exclude(File.join('log', '*.log'))
      webapp_files.exclude(File.join('tmp', 'cache', '*'))
      webapp_files.exclude(File.join('tmp', 'sessions', '*'))
      webapp_files.exclude(File.join('tmp', 'sockets', '*'))
      webapp_files.exclude(File.join('tmp', 'jetty'))
      config.excludes.each do |exclude|
        webapp_files.exclude(exclude)
      end
      copy_tree(webapp_files, staging)
      compile_tree(staging, config)
    end
    
  end  
end 
