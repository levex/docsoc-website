---
title: Add Code Syntax Highlighting to any page in "Two" Lines
author: Matthew Sojourner Newton
date: 2012-08-10 18:53
template: article.jade
---

##Background
A while back I wrote a brief post in which I shared some simple code to automatically highlight the syntax of code blocks on a blog, [Code Syntax Highlighting in Tumblr](/post/27497248050/code-syntax-highlighting-in-tumblr). I want to revisit that post for two reasons:

1. I want to more fully explain how all this works
2. I have created a small project called **prettify-wrapper** to handle most of the housekeeping, making for a packaged and streamlined code highlighting solution.

##prettify-wrapper
I created a repository on github to house the wrapper code, support code, and accompanying themes. You can link directly to it to use it on your site. Please check it out:

http://github.mnewton.com/prettify-wrapper/

## Why this method? and why google-code-prettify?
There are tons posts on this subject but most fall short of ideal. Here is why this method is better:

####It's simple. 
It involves one cut and paste and virtually no thought.
####Nothing changes on the server.
It is completely self-contained in one spot in the html. All the rendering happens client side using javascript.
####You don't have to modify html in your posts.
This solution does not require any special tags, CSS, or configuration when you post some code. Just wrap your code in `<pre><code>` tags like you see below. Blogging platforms do that anyway so for most people they do not need to do anything other than copy and paste to get the job done. 

    <pre><code>
        printf("Hello World!");
    </code></pre>

## The Code
If you just want this thing to work, copy and paste this code right before your `</body>` tag:

    <!-- ======================= Begin Prettify ============================-->
      <link rel="stylesheet" type="text/css" 
        href="http://github.mnewton.com/prettify-wrapper/themes/prettify.css">
      <script type="text/javascript"
        src="http://github.mnewton.com/prettify-wrapper/wrapper.min.js"></script>
    <!-- ======================== End Prettify =============================-->

What? You say that's more than two lines? Well, it's two statements that call upon many more lines of actual code. But it's basically two lines of code that you have to worry about. The rest is all behind the scenes.

##Credits

####The originial google-code-prettify
You can check out more about [google-code-prettify here](http://google-code-prettify.googlecode.com/svn/trunk/README.html).

####Inspiration

 * http://ghoti143.tumblr.com/post/1412901908/google-code-prettify-tumblr-love
 * http://www.codingthewheel.com/archives/syntax-highlighting-stackoverflow-google-prettify
 * http://www.avoid.org/?p=78

Feedback and Pull Requests are welcome. You can comment here or interact with the project via github.
