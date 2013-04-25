# HipSnip Cookbook Development

We use this as a central place to manage the Gem dependencies, Rake tasks and development readme that's shared
between our cookbooks. See below on how to get set up for working on a HipSnip cookbook, and how to run the tests for it.


## What you'll need to get started
These are generic dependencies which will be shared between cookbooks

* Ruby version manager of your choice ([RVM](https://rvm.io/) or [Rbenv](https://github.com/sstephenson/rbenv)). If you don't use any of those, then just make sure your Ruby version matches the one defined in `.ruby-version`.
* [Bundler](http://gembundler.com/) - `gem install bundler`
* [Vagrant](http://www.vagrantup.com/) (> 1.1.0) - download [here](http://downloads.vagrantup.com/)


## Getting cookbook dependencies
These are mostly specific to the given cookbook repository

From the root of the cookbook repo:

    bundle install
    bundle exec berks install
    vagrant plugin install berkshelf-vagrant


## Running tests

### Offline tests
These tests do not rely on a Vagrant VM, and so they can also be run as part of a Travis CI build. To run these:

    bundle exec rake cookbook:test

This will use [Strainer](https://github.com/customink/strainer) in standalone mode to create a sandbox, and run a set of tests defined in the `Strainerfile` against it:

* Syntax check using `knife test`
* Linting via [Foodcritic](http://acrmp.github.io/foodcritic/)
* Unit tests executed against a virtual chef run using [ChefSpec](https://github.com/acrmp/chefspec)

These checks run relatively quickly, so they can be used while iterating over changes to a cookbook.


### Integration tests
These tests include all the "offline" tests from above, plus a set of integration tests run against Vagrant VMs using [Test Kitchen](https://github.com/opscode/test-kitchen). To run the integration tests:

    bundle exec rake cookbook:full_test

> NOTE: The integration tests can take a while, as Test Kitchen provisions a new Vagrant VM for each test run.


## Contributing

Just a few basic rules:
* Always Make your changes in a feature branch, and then submit a pull request
* When adding new features/fixes, please add tests as well (where appropriate)
* Make sure the full integration test suite passes before you submit your changes
