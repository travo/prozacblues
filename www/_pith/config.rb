require 'date'
require 'time'
require 'active_support/core_ext/integer/inflections'
require 'pith/plugins/publication'

project.assume_content_negotiation = true
project.assume_directory_index = true

project.helpers do

  def main_header_image
    if page.meta['main_image']
      %{<style type="text/css"> header { background-image: url(#{href(page.meta['main_image'])}) } </style>}
    end
  end

  def blog_meta
    post_date = DateTime.parse(page.meta['post_date'].to_s)
    formatted_date = post_date.strftime("%e#{post_date.day.ordinal} %B %Y")
    %{
      #{topic_links}
      <p>
        <small><strong>Posted</strong></small>
        <br/>
        #{formatted_date}
      </p>
    }
  end

  def topic_links
    page.meta['topics'].split(', ').map do |topic|
      "<h5><a href=\"/blog/#{topic}/index.html\">#{topic.humanize}</a></h5>"
    end.join(' ')
  end

  def local_index(indexfile)
    relpath  = indexfile.split('/')[0..-2]
    filespec = [Dir.getwd, relpath, '*.html.haml'].flatten
    filepath = File.join(filespec)
    Dir.glob(filepath).map do |file|
      post_link(file) unless index?(file)
    end.join("\n\n")
  end

  def topic_index(topic)
    pathspec = File.join(Dir.getwd, 'www', 'blog', '**/*.html.haml')
    Dir.glob(pathspec).reverse.map do |file|
      meta = read_meta(File.open(file))
      if !index?(file) && meta['topics']
        topics = meta['topics'].split(', ')
        post_link(file, meta) if topics.include?(topic)
      end
    end.join("\n\n")
  end

  def post_link(file, pagemeta = nil)
    href = file.match(/blog.*\.html/).to_s
    meta = pagemeta || read_meta(File.open(file))
    post_date = DateTime.parse(meta['post_date'].to_s)
    formatted_date = post_date.strftime("%e#{post_date.day.ordinal} %B %Y")
    %{
      <h3><a href='/#{href}'>#{meta['title']}</a></h3>
      <p class='index-post-date'>
        <small><strong>Posted:</strong> #{formatted_date}</small>
      </p>
    }
  end


  private

  def index?(file)
    file.match(/index\.html\.haml$/) || file.match(/archives\.html\.haml$/)
  end

  YamlParseError = defined?(Psych::SyntaxError) ? Psych::SyntaxError : ArgumentError

  # Ah, for now — stolen right out of pith.
  def read_meta(io)
    header = io.gets
    if header =~ /^---/
      while line = io.gets
        break if line =~ /^(---|\.\.\.)/
        header << line
      end
      begin
        @meta = YAML.load(header)
      rescue YamlParseError => e
        puts "#{e}:1: badly-formed YAML header"
      end
    else
      io.rewind
    end
  end


end
