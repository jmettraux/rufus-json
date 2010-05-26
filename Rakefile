

require 'lib/rufus/json.rb'

require 'rubygems'
require 'rake'


#
# CLEAN

require 'rake/clean'
CLEAN.include('pkg', 'tmp', 'html')
task :default => [ :clean ]


#
# GEM

require 'jeweler'

Jeweler::Tasks.new do |gem|

  gem.version = Rufus::Json::VERSION
  gem.name = 'rufus-json'

  gem.summary = 'One interface to various JSON ruby libs (yajl, json, json_pure, json-jruby, active_support). Has a preference for yajl.'

  gem.description = %{
One interface to various JSON ruby libs (yajl, json, json_pure, json-jruby, active_support). Has a preference for yajl.
  }
  gem.email = 'jmettraux@gmail.com'
  gem.homepage = 'http://github.com/jmettraux/rufus-json/'
  gem.authors = [ 'John Mettraux', 'Torsten Schoenebaum' ]
  gem.rubyforge_project = 'rufus'

  gem.test_file = 'test/test.rb'

  gem.add_development_dependency 'json'
  gem.add_development_dependency 'yajl-ruby'
  gem.add_development_dependency 'activesupport'
  #gem.add_development_dependency 'json_pure'
  #gem.add_development_dependency 'json-jruby'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'jeweler'

  # gemspec spec : http://www.rubygems.org/read/chapter/20
end
Jeweler::GemcutterTasks.new


#
# DOC

begin

  require 'yard'

  YARD::Rake::YardocTask.new do |doc|
    doc.options = [
      '-o', 'html/rufus-json', '--title',
      "rufus-json #{Rufus::Json::VERSION}"
    ]
  end

rescue LoadError

  task :yard do
    abort "YARD is not available : sudo gem install yard"
  end
end


#
# TO THE WEB

task :upload_website => [ :clean, :yard ] do

  account = 'jmettraux@rubyforge.org'
  webdir = '/var/www/gforge-projects/rufus'

  sh "rsync -azv -e ssh html/rufus-json #{account}:#{webdir}/"
end

