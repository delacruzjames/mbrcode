# frozen_string_literal: true

require_relative "lib/mbrcode/version"

Gem::Specification.new do |spec|
  spec.name          = "mbrcode"
  spec.version       = Mbrcode::VERSION
  spec.authors       = ["Sensei James"]
  spec.email         = ["delacruzjamesmartin@gmail.com"]

  spec.summary       = "Simple and clean membership code generator."
  spec.description   = "Generates structured membership IDs like MBR1-0000-0000-0000 for apps, systems, and organizations."
  spec.homepage      = "https://github.com/delacruzjames/mbrcode"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.0.0"

  # metadata
  spec.metadata["homepage_uri"]     = spec.homepage
  spec.metadata["source_code_uri"]  = "https://github.com/delacruzjames/mbrcode"

  # Files included in the gem
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Add RSpec for testing
  spec.add_development_dependency "rspec", "~> 3.12"
end
