require 'redcarpet/compat'
require 'nokogiri'

module Jekyll
  class ExcerptBuilder < Generator
    safe true
    priority :high
    EXCERPT_LENGTH = Jekyll.configuration({})['excerpt_length'] || 200

    def generate(site)
      site.posts.map! do |post|

        unless post.data['excerpt']
          html = ::Markdown.new(post.content).to_html
          excerpt = ::Nokogiri::HTML(html).text[0..EXCERPT_LENGTH].gsub(/\n/, ' ')
          post.data['excerpt'] = excerpt.strip
        end

        post.data['excerpt'] = '<p>' + post.data['excerpt'].strip + '&hellip;</p>'
        post
      end
    end
  end
end
