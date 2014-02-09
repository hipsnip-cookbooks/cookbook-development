require 'fileutils'
require 'tmpdir'

namespace :cookbook do
  # Paths to exclude from the bundle when publishing
  if ::File.exists?(".chefignore")
    EXCLUDE_PATHS = IO.readlines('.chefignore').map{ |l| l.strip }
  else
    EXCLUDE_PATHS = [
      ".git", ".gitignore", ".rvmrc", ".ruby-version", ".travis.yml", ".kitchen.yml", "Gemfile",
      "Gemfile.lock", "Berksfile", "Berksfile.lock", "Strainerfile", "spec", "test", "Rakefile"
    ]
  end

  desc "Run Strainer to create sandbox and test cookbook"
  task :test do |t, args|
    # Figure out the names of the cookbooks available
    cookbooks_names = get_cookbooks_names(args.extras).join(' ')
    puts "=== Running Strainer... ==="
    sh "bundle exec strainer test #{cookbooks_names}"
  end

  desc "Run Strainer with fail-fast - for development"
  task :dev_test do |t, args|
    # Figure out the names of the cookbooks available
    cookbooks_names = get_cookbooks_names(args.extras).join(' ')
    puts "=== Running Strainer... ==="
    sh "bundle exec strainer test --fail-fast #{cookbooks_names}"
  end

  desc "Run Strainer and then Test Kitchen - won't work on Travis"
  task :full_test do
    Rake::Task["cookbook:test"].invoke
    puts "=== Running Test Kitchen... ==="
    Rake::Task["kitchen:all"].invoke
  end

  desc "Bundle this cookbook for the Opscode Community site"
  task :bundle do |t|
    sh "knife cookbook metadata from file metadata.rb"
    tarball_name = "#{COOKBOOK_NAME}.tar.gz"
    temp_dir = File.join(Dir.tmpdir, "chef-upload-cookbooks")
    temp_cookbook_dir = File.join(temp_dir, COOKBOOK_NAME)
    tarball_dir = PACKAGE_DIR

    FileUtils.rm_rf temp_dir if File.exists? temp_dir
    FileUtils.mkdir temp_dir
    FileUtils.mkdir temp_cookbook_dir

    cookbook_files.each do |file|
      FileUtils.cp_r(file, temp_cookbook_dir)
    end

    sh "tar -C #{temp_dir} -czvf #{File.join(tarball_dir, tarball_name)} #{COOKBOOK_NAME}"

    FileUtils.rm_rf temp_dir
  end
end


begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue StandardError, LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end


################################################################################

def cookbook_files
  Dir.glob("*").reject do |path|
    if EXCLUDE_PATHS.include? File::basename(path)
      true
    else
      false
    end
  end
end

def get_cookbooks_names(names)
  if names && (names.size > 0) then names
  elsif !cookbook_repo? then Dir['cookbooks/*'].map{|p| File.basename(p)}
  else []
  end
end

def cookbook_repo?
  cookbook_repo ||= File.exists?('metadata.rb')
end

