require_relative "lib/permit/version"

Gem::Specification.new do |spec|
  spec.name        = "permit"
  spec.version     = Permit::VERSION
  spec.authors     = ["Craig Gilchrist"]
  spec.email       = ["craig.a.gilchrist@gmail.com"]
  spec.homepage    = "https://github.com/Craggar/permit"
  spec.summary     = "A User and Role management gem for Rails 7"
  spec.description = "A User and Role management gem for Rails 7"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "http://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Craggar/permit"
  spec.metadata["changelog_uri"] = "https://github.com/Craggar/permit/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.0"
end
