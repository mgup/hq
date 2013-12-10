# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "russian"
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yaroslav Markin"]
  s.autorequire = "russian"
  s.date = "2011-10-23"
  s.description = "Russian language support for Ruby and Rails"
  s.email = "yaroslav@markin.net"
  s.extra_rdoc_files = ["README.textile", "LICENSE", "CHANGELOG", "TODO"]
  s.files = ["README.textile", "LICENSE", "CHANGELOG", "TODO"]
  s.homepage = "http://github.com/yaroslav/russian/"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Russian language support for Ruby and Rails"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<i18n>, [">= 0.5.0"])
      s.add_development_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7.0"])
    else
      s.add_dependency(%q<i18n>, [">= 0.5.0"])
      s.add_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.7.0"])
    end
  else
    s.add_dependency(%q<i18n>, [">= 0.5.0"])
    s.add_dependency(%q<activesupport>, [">= 3.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.7.0"])
  end
end
