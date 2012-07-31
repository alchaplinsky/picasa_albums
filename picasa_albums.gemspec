# -*- encoding: utf-8 -*-
require File.expand_path('../lib/picasa_albums/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alex Chaplinaky"]
  gem.email         = ["alchapone@yandex.ru"]
  gem.description = %q{Simple Google Picasa managment}
  gem.summary = %q{simple google picasa managment}
  gem.homepage = "https://github.com/alchapone/picasa_albums"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "picasa_albums"
  gem.require_paths = ["lib"]
  gem.version       = PicasaAlbums::VERSION
  
  gem.add_dependency "xml-simple"
end
