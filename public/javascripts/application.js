// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults



$(document).ready(function(){
  // Functions

   // $('element').presuggest('Suchbegriff', 'light_text')
   $.fn.presuggest = function(text, css_class) 
   {
     if ($(this).val() == '') {
       $(this).val(text).addClass(css_class);
     };
     $(this).focus(function()
             {
               if ($(this).val() == text)
               {
                 $(this).val('').removeClass(css_class);
               }
             }).
             blur(function()
             { 
               if ($(this).val() == '')
               {
                 $(this).val(text).addClass(css_class);
               }
             });
   };

   // create a table of contents and append it in the specified location
   // $("#content").TOC(settings)
   $.fn.TOC =  function(settings)
   {
     settings = $.extend({
       tocPlace: "#sidebar",
       tocHeadings: "h2,h3,h4",
       tocTitle: "Inhalt"
     }, settings || {});

     $(settings.tocHeadings).addClass('__toc');

     var toc_array = settings.tocHeadings.split(",");
     var toc_div = $("<div id='toc'>");
     toc_div.append("<a name='toc_top'/><h2>" + settings.tocTitle + "</h2>");

     var toc_list = $('<ul class="toc_level_1">');

     toc_div.append(toc_list);
     var lastLevel = 1;
     $(this).find(".__toc").each(function(){
       var $e = $(this);
       var level;
       $.each(toc_array, function(i, val){
         if ($e.is(val)) { level = i + 1;}
       });

       var li = $("<li>");
       var name = $e.attr('id');
       var text = $e.text();
       var class_name = "toc_level_" + level;

       var link = $("<a href='#" + name + "'></a>").text(text).get(0);
       li.append(link);      

       if (level == lastLevel) {
         $('ul.' + class_name + ':last', toc_div).append(li);
       } else if (level > lastLevel) {

         var parent_level = level - 1;
         var parent_class_name = "toc_level_" + parent_level;

         $('ul.' + parent_class_name + ":last", toc_div).append("<ul class='" + class_name + "'></ul>");
         $('ul.' + class_name + ':last', toc_div).append(li);
       } else if (level < lastLevel) {

         $('ul.' + class_name + ':last', toc_div).append(li);
       }
       lastLevel = level;

       var toc_link = $('<a href="#toc_top"></a>').text("top").get(0);
       $(this).after(toc_link).before("<a name=" + name + "></a>");

     });


     $(settings.tocPlace).append(toc_div);
   };

 
  // Behaviours
  $("a.ajax").click( function() {
    

      $.ajax({
          url: $(this).attr('href'),
          dataType: "script"
      });
          return false;
    });
    
    $('a[@href^=http]').addClass('extlink');
    $('input[@name=search]').presuggest('Suche', 'fieldSuggestion');
    $('input[@id=page_title]').presuggest('Seitentitel', 'fieldSuggestion');
    $('a.login_link').click(function()
                            {
                              $('#login_form').slideToggle(); 
                              return false;
                            });


    $('#main_content').TOC({tocPlace: "#sidebar", tocTitle: "Inhaltsverzeichnis"  });
 
  $(window).bind('ajaxError', function (e, xhr, s) {
    if (s.dataType == 'script' && xhr.responseText) {
      $.globalEval(xhr.responseText);        
    }
  });
});

////
// add Accept:text/javascript header to jQuery ajax requests

$.ajaxSetup({'beforeSend':function(xhr){xhr.setRequestHeader("Accept","text/javascript")}})

