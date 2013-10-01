# encoding: utf-8

module Jekyll
  class TagIndex < Page
    def initialize(site, base, tag_dir, tag)
      @site = site
      @base = base
      @dir  = tag_dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
      self.data['tag'] = tag

      # Set the title for this page.
      tag_title_prefix = site.config['tag_title_prefix'] || 'Tag: '
      self.data['title'] = "#{tag_title_prefix}#{tag}"

      # Set the meta-description for this page.
      tag_description_prefix = site.config['tag_description_prefix'] || 'Tag: '
      self.data['description'] = "#{tag_description_prefix}#{tag}"
    end
  end

  class TagIndexGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag_index'
        dir = site.config['tag_dir'] || 'tagged'
        site.tags.keys.each do |tag|
          site.pages << TagIndex.new(site, site.source, File.join(dir, tag), tag)
        end
      end
    end
  end

  module TagFilter
    def tag_links(tags)
      dir = @context.registers[:site].config['tag_dir'] || 'tagged'
      baseurl = @context.registers[:site].config['baseurl'] || ''
      tags = tags.sort!.map do |tag|
        url = "#{baseurl}/#{dir}/#{tag}/"
        "<a class='tag' href=#{url}>#{tag.capitalize}</a>"
      end
      tags.join(', ')
    end
  end
end

Liquid::Template.register_filter(Jekyll::TagFilter)
