#!/usr/bin/env rake

desc 'Publish prozacblues.com'
task publish: :build  do
  sh 'rsync -avz www/_out/* prozacblues.com:~/www/documents/'
end

desc 'Build the website using Pith.'
task :build  do
  sh 'pith -i www build'
end