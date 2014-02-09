Gem::Specification.new do |s|
  s.name                   = 'cookbook-development'
  s.version                = '0.3.0'
  s.summary                = 'Just a way to abstract our Rake tasks for Chef Cookbooks'
  s.require_path           = 'lib'
  s.authors                = ['Adam Borocz']
  s.email                  = ['adam@hipsnip.com']
  s.platform               = Gem::Platform::RUBY
  s.files                  = Dir.glob('lib/**/*.rake')
  s.required_ruby_version  = '>= 1.9.3'

  s.add_dependency "chef", "~> 11.10.0"
  s.add_dependency "foodcritic", "~> 3.0.3"
  s.add_dependency "chefspec", "~> 3.2.0"
  s.add_dependency "strainer", "~> 3.3.0"
end
