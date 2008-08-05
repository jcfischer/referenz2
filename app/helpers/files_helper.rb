module FilesHelper
  
  def link_download(file, title = nil)
    title ||= CGI.escapeHTML(file)
    link_to title, :controller => "files", :action => 'download', :params => { 'file' => file.split(".").first, 'ext' => file.split(".").last }
  end
  
end
