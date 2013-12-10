# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jquery-turbolinks"
  s.version = "2.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sasha Koss"]
  s.date = "2013-08-27"
  s.description = "jQuery plugin for drop-in fix binded events problem caused by Turbolinks"
  s.email = "koss@nocorp.me"
  s.homepage = "https://github.com/kossnocorp/jquery.turbolinks"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "jquery-turbolinks"
  s.rubygems_version = "2.0.3"
  s.summary = "jQuery plugin for drop-in fix binded events problem caused by Turbolinks"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.1.0"])
      s.add_runtime_dependency(%q<turbolinks>, [">= 0"])
    else
      s.add_dependency(%q<railties>, [">= 3.1.0"])
      s.add_dependency(%q<turbolinks>, [">= 0"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.1.0"])
    s.add_dependency(%q<turbolinks>, [">= 0"])
  end
end
