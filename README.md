# Running locally:

    # Presuming you're using rbenv:
    $ bundle install
    $ jekyll serve --watch

[http://localhost:4000/blog/index.html](http://localhost:4000/blog/index.html)

# Posts

## Writing blog posts:

### Naming

- All posts are saved under _posts as .md files.
- Follow the file name formatting of the existing posts.
- eg: 2012-12-01-permalink-to-post.md

### Post contents:

    ---
    # required
    layout: post
    title: "Awesome new blog"

    # optional
    date: 2012-11-13 14:42:00 UTC # overrides filename date
    tags: [event, social] # lower case, no underscores or weird stuff
    # see existing generated tags under _site/tagged/
    permalink: some-path # overrides the default /year/month/day/title

    # optional and custom
    author: pete # check in _config.yml for your details, add yourself if not there already

    # Optional Call to action e.g. "Register" or "See On Facebook"
    cta:
      tagline: Lorem ipsum dolar sit amet.
      linkurl: https://superawesomesite.com
    ---

    [post content in markdown]

## Adding Images

### Inserting images in posts

Insert with standard HTML as below.

```html
<img width=650 height=500 src="{{ site.url }}/assets/my_image.png" alt="Super Cool Image!">
```

**Why this long url shit?**

Beacuse it will make PRs awesome. Having a full rendered preview on GitHub. Yay!
