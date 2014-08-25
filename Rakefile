#!/usr/bin/env rake
require 'nokogiri'
require 'html2haml'
require 'pry'

namespace :process do

  def get_sibling(doc, relation)
    a = doc.at_css(".footer .column:#{relation} a")
    unless a.nil?
      a.attr('href').gsub('http://www.prozacblues.com/travo', '')
    end
  end

  def get_topics(hrefs)
    hrefs.map do |href|
      href.attr('href').gsub('http://www.prozacblues.com/travo/blog/', '').gsub('/', '')
    end.join(', ')
  end


  desc 'Remove the cruft from Travos blog'
  task :blog do

    htmlfiles = File.join(Dir.getwd, 'www', 'blog', '**', '*.html')
    Dir.glob(htmlfiles) do |file|

      puts file
      @doc = Nokogiri::HTML(File.open(file))

      if file.match(/index.html$/)
        print 'i'

        post_title = @doc.at_css('h1.title').text
        file_body = <<TXT
---
layout: '/_layout.html.haml'
main_image: '/images/guide-to-pants-off-living-rocks.jpg'
persona: 'Index'
title: #{post_title}
...
%article.col-3-4
  %h1 #{post_title}
  = local_index(__FILE__)
%aside.col-1-4

TXT
      else
        print 'c'

        post_date = Date.parse(@doc.css('.sidebar strong').first.text)
        post_title = @doc.at_css('.content h2 a').text
        post_prev = get_sibling(@doc, 'first-child')
        post_next = get_sibling(@doc, 'last-child')
        post_topics = get_topics(@doc.css('div.sidebar a'))


        post_body = @doc.at_css('#p_666')
        post_body.at_css('div.sidebar').remove

        post_body.at_css('h2:first-child').remove

        h1 = Nokogiri::XML::Node.new 'h1', post_body
        h1.content = post_title
        post_body.at_css('p:first-child').add_previous_sibling(h1)
        post_body = Hpricot(post_body.inner_html.to_s).to_haml(4, {})

file_body = <<TXT
---
layout: '/_post.html.haml'
main_image: '/images/guide-to-pants-off-living-rocks.jpg'
persona: 'Post'
title: #{post_title}
published: #{post_date}
next_item: #{post_next}
previous_item: #{post_prev}
topics: #{post_topics}
...
%article.col-3-4
  #{post_body.gsub(/\n/, "\n  ")}
%aside.col-1-4
  ~ include('/_post_meta.html.haml')
TXT
      end

      outfile = File.open("#{file}.haml", 'w+')
      outfile.puts(file_body)
      outfile.close

    end



  end
end