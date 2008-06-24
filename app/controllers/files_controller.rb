
    class MissingFile < ActionController::ActionControllerError #:nodoc:
    end

#class FileController < AbstractApplicationController
class FilesController < ApplicationController
    include FilesHelper

    layout 'referenz'
    skip_before_filter :login_required


  protected
    def base_path
      if RAILS_ENV == 'production'
        "/opt/rails/rails-praxis/current/files" 
      else
        "#{RAILS_ROOT}/files"
      end
    end

    def permit_file?(path)
        true
        #@session['user'] and @session['user'].permit_file?(path)
    end

  public
    def index
      @files = [['1683_inhalt.pdf', 'Inhaltsverzeichnis'],
                ['1683_einleitung.pdf', 'Einleitung'],
                ['1683_kap11.pdf', '11. RSpec und Userstories'],
                ['1683_index.pdf', 'Index']
            ]
      @counts = {}
      @files.each do |fname, _|
        @counts[fname] = Download.find_or_create_by_file(fname).count
      end
    end

    def download
      begin
        fname = "#{params[:file]}.#{params[:ext]}"
        path = sanitize_file_path(fname, base_path)
        raise MissingFile, 'permission denied' unless permit_file? path
        download = Download.find_or_create_by_file fname
        download.increment! :count
        if http_if_modified_since? path
          send_file path
        else
          render :text => '', :status => 304
        end

        rescue MissingFile => e
          flash['error'] = "Download error: #{e}" 
          redirect_to :action => 'index'
        end
    end

  protected
    # Safely resolve an absolute file path given a malicious filename.
    def sanitize_file_path(filename, base_path)
        # Resolve absolute path.
        path = File.expand_path("#{base_path}/#{filename}")
        logger.info("Resolving file download:  #{filename}\n => #{base_path}/#{filename}\n => #{path}") unless logger.nil?

        # Deny ./../etc/passwd and friends.
        # File must exist, be readable, and not be a directory, pipe, etc.
        raise MissingFile, "couldn't read #{filename}" unless
            path =~ /^#{File.expand_path(base_path)}/ and
            File.readable?(path) and
            File.file?(path)

        return path
    end

    # Check whether the file has been modified since the date provided
    # in the If-Modified-Since request header.
    def http_if_modified_since?(path)
        if since = request.env['HTTP_IF_MODIFIED_SINCE']
            begin
                require 'time'
                since = Time.httpdate(since) rescue Time.parse(since)
                return since < File.mtime(path)
            rescue Exception
            end
        end
        return true
    end
end
