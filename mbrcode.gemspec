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

  spec.metadata["homepage_uri"]     = spec.homepage
  spec.metadata["source_code_uri"]  = spec.homepage

  # Correct file discovery
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0")
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.12"
end
