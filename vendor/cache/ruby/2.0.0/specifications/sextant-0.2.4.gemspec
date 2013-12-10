# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sextant"
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Schneeman"]
  s.date = "2013-06-14"
  s.description = "Sextant is a Rails engine that quickly shows the routes available"
  s.email = ["richard.schneeman+rubygems@gmail.com"]
  s.homepage = "https://github.com/schneems/sextant"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Sextant is a Rails engine that quickly shows the routes available."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.2"])
      s.add_development_dependency(%q<capybara>, [">= 0.4.0"])
      s.add_development_dependency(%q<launchy>, ["~> 2.1.0"])
      s.add_development_dependency(%q<poltergeist>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 3.2"])
      s.add_dependency(%q<capybara>, [">= 0.4.0"])
      s.add_dependency(%q<launchy>, ["~> 2.1.0"])
      s.add_dependency(%q<poltergeist>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.2"])
    s.add_dependency(%q<capybara>, [">= 0.4.0"])
    s.add_dependency(%q<launchy>, ["~> 2.1.0"])
    s.add_dependency(%q<poltergeist>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
