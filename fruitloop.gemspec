Gem::Specification.new do |s|
  s.name = 'fruitloop'
  s.version = '0.3'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.md', 'MIT-LICENSE']
  s.summary = 'FRUITLOOP is an implementation of the LOOP programming language.'
  s.description = 'FRUITLOOP is an implementation of the LOOP programming language.' 
  s.author = 'Thomas Hoefer'
  s.email = 'mail@tomhoefer.de'
  s.homepage = 'http://www.github.com/thoefer/fruitloop'
  s.files = %w(MIT-LICENSE README.md Rakefile) + Dir.glob("{lib}/**/*")
  s.require_path = "lib"
end

