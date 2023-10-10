require_relative "lib/permits/version"

Gem::Specification.new do |spec|
  spec.name        = "permits"
  spec.version     = Permits::VERSION
  spec.authors     = ["Craig Gilchrist"]
  spec.email       = ["craig.a.gilchrist@gmail.com"]
  spec.homepage    = "https://github.com/Craggar/permits"
  spec.summary     = "A User and Role management gem for Rails 7"
  spec.description = "Provides access authorization for owners and resources, via a simple Permission ActiveRecord model and a Policy class."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Craggar/permits"
  spec.metadata["changelog_uri"] = "https://github.com/Craggar/permits/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", "~> 7.1"
  spec.add_dependency "timelines", "~> 0.1"

  spec.add_development_dependency 'dotenv', "~> 2.8"
  spec.add_development_dependency 'rails', '~> 7.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rspec-rails', '~> 4.0'
  spec.add_development_dependency "simplecov", "~> 0.21"
end
