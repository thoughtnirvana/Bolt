require 'rubygems'
require 'rake'

Gem::Specification.new do |s|
  s.name = %q{benofsky-bolt}
<<<<<<< HEAD
  s.version = "0.1.7"
=======
  s.version = "0.1.6"
>>>>>>> 851ed47644f2c8ba113be26299acabdc0d698129
  s.date = %q{2010-01-08}
  s.authors = ["Ben McRedmond"]
  s.email = %q{ben+bolt@benmcredmond.com}
  s.homepage = %q{http://github.com/benofsky/bolt/}
  s.has_rdoc = true 
  
  s.summary = %q{Bolt is a simple static website generator with great support for dynamic content insertion.}
  s.description = %q{Bolt was built to fill a gap in static website generators. Bolt makes it really really simple to generate a static website with dynamic content inserted at compile time.}
  
  s.require_paths = ['lib']
  s.files = FileList['lib/**/*.rb', 'bin/*', 'LICENSE', 'default_files/*']
  
  s.bindir = ["bin"]
  s.executables = ["bolt"]
  
  s.add_dependency('haml', '>= 2.2')
end
