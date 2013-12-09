# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ace-rails-ap"
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Cody Krieger"]
  s.date = "2013-02-03"
  s.description = "The Ajax.org Cloud9 Editor (Ace) for the Rails 3.1 asset pipeline."
  s.email = ["cody@codykrieger.com"]
  s.homepage = "https://github.com/codykrieger/ace-rails-ap"
  s.require_paths = ["lib"]
  s.rubyforge_project = "ace-rails-ap"
  s.rubygems_version = "2.0.3"
  s.summary = "The Ajax.org Cloud9 Editor (Ace) for the Rails 3.1 asset pipeline."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 3.1"])
    else
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 3.1"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 3.1"])
  end
end
