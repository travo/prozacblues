require 'date'
require 'time'
require 'active_support/core_ext/integer/inflections'
require 'pith/plugins/publication'

project.helpers do

  def input_for_index(topic = nil)
    if topic
      posts = posts_by_topic(topic)
      sorted(posts).reverse
    else
      path = File.dirname(page.file)
      posts = posts_by_path(path)
      sorted(posts)
    end
  end

  def posts_by_path(path)
    project.inputs.select do |input|
      next  if input.ignorable? || index?(input.file.to_s)
      input if input.file.to_s.match(path)
    end
  end

  def posts_by_topic(topic)
    project.inputs.select do |input|
      next  if input.ignorable? || index?(input.file.to_s) || input.meta['topics'].nil?
      input if input.meta['topics'].include?(topic)
    end
  end

  def recent_posts(count)
    all_posts.take(count)
  end

  def all_posts
    posts = posts_by_path('/blog')
    sorted(posts).reverse
  end

  def sorted(posts)
    posts.sort_by { |post| post.published_at }
  end

  def main_header_image
    if page.meta['main_image']
      %{<style type="text/css"> header { background-image: url(#{href(page.meta['main_image'])}) } </style>}
    end
  end

  def formatted_date(date)
    post_date = DateTime.parse(date.to_s)
    post_date.strftime("%e#{post_date.day.ordinal} %B %Y")
  end

  def topic_links
    page.meta['topics'].split(', ').map do |topic|
      "<h5><a href=\"/blog/#{topic}/index.html\">#{topic.humanize}</a></h5>"
    end.join(' ')
  end

  private

  def index?(file)
    file.match(/index\.html\.haml$/) || file.match(/archives\.html\.haml$/)
  end

end
