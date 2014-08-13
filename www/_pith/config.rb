require 'date'
require 'time'
require 'active_support/core_ext/integer/inflections'

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

  def local_index(file)
    %{FILE: #{file}}
  end

end
