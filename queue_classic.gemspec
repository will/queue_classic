#encoding: UTF-8
Gem::Specification.new do |s|
  s.name          = "queue_classic"
  s.email         = "ryan@heroku.com"
  s.version       = "2.0.1"
  s.date          = "2012-07-23"
  s.description   = "queue_classic on redis"
  s.summary       = "redis backed queue"
  s.authors       = ["Ryan Smith (♠ ace hacker)", "will"]
  s.homepage      = "http://github.com/will/queue_classic"
  s.license       = "MIT"

  files = []
  files << "readme.md"
  files << Dir["{lib,test}/**/*.rb"]
  s.files = files
  s.test_files = s.files.select {|path| path =~ /^test\/.*_test.rb/}

  s.require_paths = %w[lib]

  s.add_dependency "scrolls", "~> 0.2.1"
  s.add_dependency "hiredis", "~> 0.4.5"
  s.add_dependency "redis",   "~> 3.0.3"
end
