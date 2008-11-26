# use like this: script/runner lib/conv_xml.rb 
# xml files have to be in directory RAILS_ROOT/book

require 'rexml/document'
require 'rexml/streamlistener'
include REXML
include REXML::StreamListener

# stream-based parsing
# the code is harder to follow and more verbose, but it
# performs far better
class StreamChapterParser
  
  include StreamListener
  @@body_tags = ['standard', 'standardm', 'kastenstandard', 'uberschrift3', 'uberschrift4', 
                  'antwortmehrfach', 'listingzeichen', 'gliederungspunkt', 'gliederungspunkt2ebene', 'aufzahlung1', 
                 'kastentitel',
                 'listingzeichenfettlisting', 'listingunterschrift', 'listingzeichenkursiv', 'listingzeichenlistingtitel',
                 'listingzeichentab', 'listingzeichenfussnote', 'listingzeichenfett', "listingzeichenbildtitel",
                 'zitat', 'aufzahlungeinzug', 'aufzahlung234', 'nobr', 'icontext', 
                 'a', 'fett', 'kursiv', 'sup', 'hr', 'ol', 'li', 'kapitalchen',
                 'tastenkappe',
                 'listing', 'tabellentext', 'tabellenkopf', "caption", "tabellenunterschrift", 
                 'img', 'bildunterschrift', 'butulu']
  @@after_list_tags = ['standard']
  @@skip_tags = ['gp', 'gp2', 'bild', 'hochgestellt', 'weiss', 'kommentarzeichen', 'anmerken']
  @@list_tags = ['antwortmehrfach', 'aufzahlung1', 'gliederungspunkt', 'aufzahlung234', 'aufzahlungeinzug']
  
  def initialize
    @in_section = nil
    @in_chapter_title = false
    @in_section_title = false
    @in_intro = false
    @in_listing = false
    @in_table = false
    @in_caption = false
    @in_tablehead = false
    @in_row = false
    @in_body = false
    @chapter = nil
    @section = nil
    @html = ""
    @stack = []
  end

  def tag_start(tag_name, attrs)
    
    @stack.push tag_name
    # p @stack
    if @@skip_tags.include?(tag_name)
      @skipping = true
    end
    @current_tag = tag_name
    # handle lists
    if @in_list && @@after_list_tags.include?(tag_name)
      @html << "\n</#{@list_tag}>"
      @in_list = false
    end

    case tag_name
    when "uberschrift0"
      @in_chapter_head = true

      @chapter = Chapter.new
    when 'uberschrift1'

      @in_chapter_title = true
      @html = ""
      @in_title = true
      @title = ''
    when 'uberschrift2'
      if @chapter.new_record?
        @chapter.body = @html
        @chapter.save
        @in_chapter = false
      end
      if @section
        @section.body = @html
        @section.save
      end
      @in_section = true
      @in_section_title = true
      @in_title = true
      @title = ''
      @section = Section.new
      @section.chapter = @chapter
      @html = ''
    when 'uberschrift3'
      @html << "\n<h3>"
    when 'uberschrift4'
      @html << "\n<h4>"
    when 'uberschrift5'
      @html << "\n<h5>"
    when 'standard', 'standardm', 'kastenstandard'
      @html << "</code></pre>\n" if @in_listing
      @in_listing = false
      @html << "<p>\n"
    when 'zitat'
      @html << "\n<blockquote>"
    when 'a'
      attr = attrs.collect { |k,v| "#{k}=\"#{v}\"" }.join(' ')
      @html << "<a #{attr}>"
    when 'antwortmehrfach', 'aufzahlung1', 'gliederungspunkt', 'aufzahlung234'
      if @in_2_list
        @html << "\n</ul>\n"
        @in_2_list = false
      end
      unless @in_list
        
        @list_tag = tag_name == 'anzahl1' ? 'ol' : 'ul'
        @html << "\n<#{@list_tag}>\n"
        @in_list = true
      end
      @in_list_item = true
      @html << "\n<li>"
    when 'gliederungspunkt2ebene'
      unless @in_2_list
        @html << "\n<ul>\n"
        @in_2_list = true
      end
      @in_list_item = true
      @html << "\n<li>"
    when 'aufzahlungeinzug'
      @html << "\n<div class=\"indent\">\n"
    when 'table'
      # handle the listing tables

      @in_listing = false
    when 'caption'
      attr = attrs.collect { |k,v| "#{k}=\"#{v}\"" }.join(' ')
      @caption = "\n<caption #{attr}>\n"
      @in_caption = true
    when 'tabellenkopf'
      unless @in_tablehead
        @html << "\n<table>\n#{@caption}\n<tr>\n  <th>\n"
        @caption = ''
        @in_table = true
        @in_tablehead = true
      end
    when 'tabellentext'
      unless @in_table
        @html << "\n<table>\n#{@caption}\<tr>\n  <td>\n"
        @caption = ''
        @in_table = true
      end
    when 'tr'
      @html << "\n<tr>" if @in_table
      @in_tablehead = false
    when 'td'
      if @in_tablehead
        @html << '<th>'
      else
        @html << "\n  <td>" if @in_table
      end
      
    when 'listing'
      @html << "\n<pre><code>" unless @in_listing
      @in_listing = true
    when 'listingunterschrift'
      @html << "</code></pre>\n" if @in_listing
      @in_listing = false
      @html << '<p class="listingcaption">'
    when 'listingzeichenlistingtitel', "listingzeichentab", 'listingzeichenfussnote', 'listingzeichenbildtitel'
      @html << '<code>'
    when 'kastentitel'
      @in_kasten = true
      @html << "\n<div class=\"box\">\n<h2>"
    when 'listingzeichen'
      @in_listingz = true
      @html << '<code>'
    when 'fett'
      @html << '<em class="bold">'
    when 'listingzeichenfett', 'listingzeichenfettlisting'
      @html << '<code><em class="bold">'

    when 'kursiv'
      @html << '<em>'
    when 'listingzeichenkursiv'
      @html << '<code><em>'
    when 'sup'
      @html << '<sup>'
    when 'hr'
      @html << "\n<hr />\n"
    when 'ol'
      @html << "\n<ol>\n"
    when 'li'
      @html << "\n<li>"
    when 'kapitalchen'
      @html << '<em class="capitals">'
    when 'gp', 'bild', 'nobr', 'icontext', 'tabellenunterschrift', 'anmerken', 'tastenkappe'
    when 'br'
      @html << "\n<br />"
    when 'img'
      file = attrs['src']
      @html << "\n<img src=\"/images/book/#{file}\" />"
    when 'bildunterschrift'
      @html << "\n<div class=\"caption\">"
    when 'butulu'
      @html << "<em>"
    else
      puts tag_name  unless @@skip_tags.include?(tag_name)
    end
  end
  
  def tag_end(tag_name)
    if @@skip_tags.include?(tag_name)
      #puts 'skip false'
      @skipping = false

    end
    case tag_name
    when 'uberschrift0'
      @in_chapter_head = false
    when 'uberschrift1'
      @in_chapter_title = false
      @chapter.title = @title
      @in_title = false
    when 'uberschrift2'
      @in_section_title = false
      @section.title = @title
      @in_title = false
    when 'uberschrift3'
      @html << "</h3>\n"
    when 'uberschrift4'
      @html << "</h4>\n"
    when 'uberschrift5'
      @html << "</h5>\n"
    
    when 'standard', 'standardm', 'kastenstandard'
      @html << "</p>\n"
    when 'antwortmehrfach', 'aufzahlung1', 'gliederungspunkt', 'aufzahlung234', 'gliederungspunkt2ebene'
      @html << "</li>\n"
      @in_list_item = false
    when 'aufzahlungeinzug'
      @html << "\n</div>\n"
    when 'zitat'
      @html << "</blockquote>\n"
    when 'a'
      @html << '</a>'
    when 'listingzeichen'
      @html << '</code>'
      @in_listingz = false
    when 'listing'
      @html << "\n"
    when 'listingzeichenlistingtitel', 'listingzeichentab', 'listingzeichenfussnote', 'listingzeichenbildtitel'
      @html << '</code>'
    when 'listingzeichenkursiv', 'listingzeichenfettlisting', 'listingzeichenfett'
      @html << '</em></code>'
    when 'listingunterschrift'
      @html << '</p>'
    when 'table'
      @html << "\n</table>" if @in_table
      @in_table = false
      @html << "</code></pre>\n" if @in_listing
      @in_listing = false
      @html << "\n</div>\n" if @in_kasten
      @in_kasten = false
    when 'caption'
      @caption << "\n</caption>"
      @in_caption = false
    when 'kastentitel'
      @html << "</h2>\n"
    when 'tr'
      @html << "\n</tr>\n" if @in_table
    when 'td'
      if @in_tablehead
        @html << "</th>"
      else
        @html << "\n  </td>\n" if @in_table
      end
    when 'fett', 'kursiv', 'kapitalchen'
      @html << '</em>'

    when 'sup'
      @html << '</sup>'
    when 'ol'
      @html << "\n</ol>\n"
    when 'li'
      @html << "</li>\n"
    when 'img'
    when 'bildunterschrift'
      @html << "</div>\n"
    when 'butulu'
      @html << '</em>'
    when 'doc'
      if @section
        @section.body = @html
        @section.save
      end
    end
    
    @stack.pop
    @current_tag = @stack[-1]
    # p "current: #{@current_tag}"
  end


  def text(value)

    return if @skipping

    if @in_chapter_head
      @chapter.number = value.split.last
    end
    
    if @in_title
      @title << value.gsub(/\n/, "")
    end
    
    if @@body_tags.include?(@current_tag)
      value = CGI::escapeHTML(value) if @in_listing
      if @in_caption
        @caption << value.gsub(/\n/, "")
      else
        @html << value.gsub(/\n/, "")
      end
    end
  end
  
end

Chapter.destroy_all
Section.destroy_all
xmlfiles = File.join('book', '*.xml')
Dir.glob(xmlfiles).each do |file|
  puts "**** #{file}"
  source = File.new file 
  REXML::Document.parse_stream(source, StreamChapterParser.new)
end
