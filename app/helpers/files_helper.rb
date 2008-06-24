module FilesHelper
  
  def link_download(file, title = nil)
    title ||= CGI.escapeHTML(file)
    link_to title, :controller => "files", :action => 'download', :params => { 'file' => file }
  end
  
end
