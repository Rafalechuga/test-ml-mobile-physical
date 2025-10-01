# -*- encoding: utf-8 -*-
# stub: appium_lib 11.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "appium_lib".freeze
  s.version = "11.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["code@bootstraponline.com".freeze, "Kazuaki Matsuo".freeze]
  s.date = "2021-01-25"
  s.description = "Ruby library for Appium.".freeze
  s.email = ["code@bootstraponline.com".freeze, "fly.49.89.over@gmail.com".freeze]
  s.homepage = "https://github.com/appium/ruby_lib".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4".freeze)
  s.rubygems_version = "3.4.19".freeze
  s.summary = "Ruby library for Appium".freeze

  s.installed_by_version = "3.4.19" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<appium_lib_core>.freeze, ["~> 4.1"])
  s.add_runtime_dependency(%q<nokogiri>.freeze, ["~> 1.8", ">= 1.8.1"])
  s.add_runtime_dependency(%q<tomlrb>.freeze, ["~> 1.1"])
  s.add_development_dependency(%q<appium_thor>.freeze, ["~> 1.1", ">= 1.1.4"])
  s.add_development_dependency(%q<fakefs>.freeze, ["~> 1.3.0"])
  s.add_development_dependency(%q<hashdiff>.freeze, ["~> 1.0.0"])
  s.add_development_dependency(%q<posix-spawn>.freeze, ["~> 0.3"])
  s.add_development_dependency(%q<pry>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<rubocop>.freeze, ["= 1.8.1"])
  s.add_development_dependency(%q<spec>.freeze, ["~> 5.3", ">= 5.3.4"])
  s.add_development_dependency(%q<yard>.freeze, ["~> 0.9.11"])
end
