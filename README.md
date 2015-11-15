# Running locally:

Install [node.js](http://nodejs.org), clone this repo and run

    $ make
    $ make preview

Then open [http://localhost:8080](http://localhost:8080)

# Posts

## Writing blog posts:

### Syntax

Posts should be written in [Markdown](http://daringfireball.net/projects/markdown/syntax).

They're parsed with [marked](https://github.com/chjj/marked)

### Naming

- Create a folder in `contents/articles` with the structure `YYYY-MM-DD-IDENTIFIER`
- Create a file index.md in that folder
- Add any images etc in that folder too

See existing posts for examples, like [this one](https://github.com/icdocsoc/website/blob/master/contents/articles/2013-11-19-amazon-office-visit)

### Post contents:

- At the top, add metadata:

      ```
      ---
      title: Silicon Valley Comes to Imperial # Title of article
      author: DoCSoc                          # Must match author name - see below
      date: 2011-11-06 10:00                  # Get it right! Shows up on article
      template: article.jade                  # In general, don't change
      ---
      ```
- Ensure you have an "author" record.
    - In `contents/_authors` add a file `My Name.json`
    - Inside the file, add your name, a URL to a photo (gravatars are good) and a URL to your personal site (optional). For an example, see [Pete Hamilton's author file](https://github.com/icdocsoc/website/blob/master/contents/_authors/Peter%20Hamilton.json)

## Adding Images

### Inserting images in posts

- Add images in the post's folder.
- Insert into post like you would in normal markdown. Relative to the index.md file

## Deployment

If you have permission to write to the [icdocsoc.github.io](https://github.com/icdocsoc/icdocsoc.github.io) repo, you can deploy the current version of the site on your machine at any time with:

    make deploy

Bear in mind for this, you'll also need [ImageMagick](http://www.imagemagick.org/) to be installed so it can resize images for the web. On mac this can be done with [HomeBrew](http://brew.sh/) and `brew install imagemagick`.
