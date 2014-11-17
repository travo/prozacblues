#!/usr/bin/env rake
require 'pry'
require 'erb'
require 'active_support/inflector'
require 'fileutils'

I18n.enforce_available_locales = false

def post_template
  File.read(File.join(Dir.getwd, 'www', '_pith', 'post_template.html.erb'))
end


desc 'Publish prozacblues.com'
task publish: :build  do
  sh 'rsync -avz www/_out/* prozacblues.com:~/www/documents/'
end

desc 'Build the website using Pith.'
task :build  do
  sh 'pith -i www build'
end

desc "'Bootstrap a new blog post — rake post['Do Doing Done']'"
task :post, [:title] do |t, args|
  title = args[:title]
  slug  = title.parameterize
  date = DateTime.now
  post_date = date.strftime("%Y-%m-%d")
  dir_date = date.strftime("%Y/%m")
  post_dir = FileUtils.mkdir_p([Dir.getwd, 'www', 'blog', dir_date].join('/'))

  File.open(File.join(post_dir, "#{slug}.html.md"), 'w+') do |file|
    file.write(ERB.new(post_template).result(binding))
  end
  puts 'Boom! Drafted'
end
