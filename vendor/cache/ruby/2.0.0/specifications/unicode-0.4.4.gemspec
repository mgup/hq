# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "unicode"
  s.version = "0.4.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yoshida Masato"]
  s.date = "2013-02-07"
  s.description = "Unicode normalization library."
  s.email = "yoshidam@yoshidam.net"
  s.extensions = ["ext/unicode/extconf.rb"]
  s.extra_rdoc_files = ["README"]
  s.files = ["README", "ext/unicode/extconf.rb"]
  s.homepage = "http://www.yoshidam.net/Ruby.html#unicode"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Unicode normalization library."
end
