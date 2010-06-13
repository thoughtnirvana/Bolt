require 'rubygems'
require 'rake'

Gem::Specification.new do |s|
  s.name = %q{benofsky-bolt}
  s.version = "0.4.2"
  s.date = %q{2010-06-13}
  s.authors = ["Ben McRedmond"]
  s.email = %q{ben+bolt@benmcredmond.com}
  s.homepage = %q{http://github.com/benofsky/bolt/}
  s.has_rdoc = true 
  
  s.summary = %q{Bolt is a simple static website generator with great support for dynamic content insertion.}
  s.description = %q{Bolt was built to fill a gap in static website generators. Bolt makes it really really simple to generate a static website with dynamic content inserted at compile time.}
  
  s.require_paths = ['lib']
  s.files = FileList['lib/**/*.rb', 'lib/**/**/*.html', 'bin/*', 'LICENSE', 'default_files/*']
  
  s.bindir = ["bin"]
  s.executables = ["bolt"]
  
  s.add_dependency('haml', '>= 2.2')
end
