require 'rubygems'
require 'rake'

Gem::Specification.new do |s|
  s.name = %q{bolt}
  s.version = "0.1.0"
  s.date = %q{2010-01-08}
  s.authors = ["Ben McRedmond"]
  s.email = %q{ben+bolt@benmcredmond.com}
  s.homepage = %q{http://github.com/benofsky/bolt/}
  s.has_rdoc = true 
  
  s.summary = %q{Bolt is a simple static website generator with support for dynamic content.}
  s.description = %q{Bolt was built to fill a gap in static website generators, making it super easy to generate a static website with dynamic content.}
  
  s.require_paths = ['lib']
  s.files = FileList['lib/**/*.rb', 'bin/*', 'LICENSE', 'default_files/*']
  
  s.bindir = ["bin"]
  s.executables = ["bolt"]
  
  s.add_dependency('activesupport', '>= 2.3.4')     
end