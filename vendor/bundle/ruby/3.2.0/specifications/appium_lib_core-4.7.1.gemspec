# -*- encoding: utf-8 -*-
# stub: appium_lib_core 4.7.1 ruby lib

Gem::Specification.new do |s|
  s.name = "appium_lib_core".freeze
  s.version = "4.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kazuaki MATSUO".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-09-27"
  s.description = "Minimal Ruby library for Appium.".freeze
  s.email = ["fly.49.89.over@gmail.com".freeze]
  s.homepage = "https://github.com/appium/ruby_lib_core/".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4".freeze)
  s.rubygems_version = "3.4.19".freeze
  s.summary = "Minimal Ruby library for Appium.".freeze

  s.installed_by_version = "3.4.19" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<selenium-webdriver>.freeze, ["~> 3.14", ">= 3.14.1"])
  s.add_runtime_dependency(%q<faye-websocket>.freeze, ["~> 0.11.0"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 1.14"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<yard>.freeze, ["~> 0.9.11"])
  s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
  s.add_development_dependency(%q<minitest-reporters>.freeze, ["~> 1.1"])
  s.add_development_dependency(%q<webmock>.freeze, ["~> 3.14.0"])
  s.add_development_dependency(%q<rubocop>.freeze, ["= 1.12.1"])
  s.add_development_dependency(%q<appium_thor>.freeze, ["~> 1.0"])
  s.add_development_dependency(%q<pry>.freeze, [">= 0"])
  s.add_development_dependency(%q<pry-byebug>.freeze, [">= 0"])
  s.add_development_dependency(%q<parallel_tests>.freeze, [">= 0"])
  s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
end
