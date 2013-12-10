# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "devise-i18n"
  s.version = "0.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christopher Dell"]
  s.date = "2013-10-29"
  s.description = "Translations for the devise gem"
  s.email = "chris@tigrish.com"
  s.extra_rdoc_files = ["LICENSE.txt", "README.md"]
  s.files = ["LICENSE.txt", "README.md"]
  s.homepage = "http://github.com/tigrish/devise-i18n"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Translations for the devise gem"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 2.8.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.2"])
      s.add_development_dependency(%q<jeweler>, ["> 1.6.4"])
      s.add_development_dependency(%q<i18n-spec>, [">= 0.4.0"])
      s.add_development_dependency(%q<localeapp>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 2.8.0"])
      s.add_dependency(%q<bundler>, ["~> 1.2"])
      s.add_dependency(%q<jeweler>, ["> 1.6.4"])
      s.add_dependency(%q<i18n-spec>, [">= 0.4.0"])
      s.add_dependency(%q<localeapp>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.8.0"])
    s.add_dependency(%q<bundler>, ["~> 1.2"])
    s.add_dependency(%q<jeweler>, ["> 1.6.4"])
    s.add_dependency(%q<i18n-spec>, [">= 0.4.0"])
    s.add_dependency(%q<localeapp>, [">= 0"])
  end
end
