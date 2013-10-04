---
title: Code Syntax Highlighting in Tumblr
author: Matthew Sojourner Newton
date: 2012-05-24 14:42
template: article.jade
---

**Edited 08/10/2012: See updated post: [Add Code Syntax Highlighting to any page in “Two” Lines](/post/29164259480/add-code-syntax-highlighting-to-any-page-in-two-lines)**

It aggravates me that no blogging platform makes it easy to enable code highlighting. Oh well, at least tumblr makes it easy to edit HTML manually to include code highlighting.

I put together the code highlighting on this blog using the following two posts as guidelines:

 * http://ghoti143.tumblr.com/post/1412901908/google-code-prettify-tumblr-love
 * http://www.codingthewheel.com/archives/syntax-highlighting-stackoverflow-google-prettify

Both of those posts are great, but I'm a minimalist so I want to make the whole process a bit easier. You can highlight all of your code blocks with one block that you can copy and paste into your html file right before the `</body>` tag:


    <!-- prettify -->
    <link href="http://google-code-prettify.googlecode.com/svn/trunk/src/prettify.css" type="text/css" rel="stylesheet"/>
    <script src="http://google-code-prettify.googlecode.com/svn/trunk/src/prettify.js" type="text/javascript"></script>
    <style>
    pre.prettyprint {
    overflow-x: auto;
    margin: 5px 20px 20px;
    }
    </style>
    <script type="text/javascript">
    function styleCode() 
    {
      if (typeof disableStyleCode != "undefined") 
      {
        return;
      }

    var a = false;

      $("pre code").parent().each(function() 
      {
        if (!$(this).hasClass("prettyprint")) 
        {
            $(this).addClass("prettyprint");
            a = true
        }
      });

      if (a) { prettyPrint() } 
    }

    $(function() {
     
        styleCode();

    });
    </script>
    <!-- end prettify -->

