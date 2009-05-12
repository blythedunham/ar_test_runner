class ArTestRunner
  
  attr_reader :auto_skip
  
  unless defined? ADAPTERS
    ADAPTERS = %w( mysql postgresql sqlite sqlite3 firebird db2 oracle sybase openbase frontbase jdbcmysql jdbcpostgresql jdbcsqlite3 jdbcderby jdbch2 jdbchsqldb )
    REQUIRE_ALL_GLOB= %w(vendor/plugins/**/init.rb lib/*.rb)
    DEFAULT_REQUIRES = [File.join(File.dirname(__FILE__), 'ar_test_runner_includes.rb')]
  end
  
  #run the whole thing
  def self.run!
    new.run
  end
  
  # Run the unit tests
  def run
    print_info
    
    return true if ENV['DRY_RUN'] == 'true'
    
    old_dir, old_env = Dir.pwd, ENV['RUBYOPT']
    
    Dir.chdir(activerecord_dir)
    ENV['LOAD_PATH'] = ''
    ENV['RUBYOPT'] = required_files.collect{|f| "-r#{f}"}.join(' ')#"-r rubygems -ractiverecord.rb -r#{init_file}"

    load "Rakefile"
    Rake::Task[ "test_#{adapter}" ].invoke
    Dir.chdir(old_dir)
    ENV['RUBYOPT'] = old_env
  end
  
  #a list of files to require run running the ActiveRecord test suite
  def required_files
    return @required_files unless @required_files.blank?
    @required_files = DEFAULT_REQUIRES.dup
    @required_files.concat(requires)
    @required_files.concat(plugins)
    @required_files.concat(expanded_files)
    @required_files.concat(default_app_files) if use_all_app_files?
    skip_files!(@required_files)
    @required_files
  end
  
  # the database adapter to use
  def adapter
    @adapter ||= begin
      adpt = ENV['DB']||'mysql'
      error_and_exit("Database type not supported #{@adapter}") unless ADAPTERS.include?(adpt)
      adpt
    end
  end
  
  # The default activerecord directory used by the app (in LOADPATH)
  def default_activerecord_dir
    @default_activerecord_dir ||= if (activerecord_lib_dir = $LOAD_PATH.detect {|f| f =~ /activerecord/})
      File.expand_path(File.dirname(activerecord_lib_dir))
    end
  end

  # Get the activerecord from AR_DIR or default to app's LOADPATH
  # ENV['AR_DIR'] should be set
  def activerecord_dir
    @activerecord_dir ||= begin
      ar_dir = (ENV['AR_DIR']||= default_activerecord_dir)
      error_and_exit "Pass in the path to ActiveRecord. Eg: AR_DIR=/Library/Ruby/Gems/1.8/gems/activerecord-2.3.2" if ar_dir.nil?
      error_and_exit "Invalid ActiveRecord directory: #{ar_dir}" unless File.directory?(ar_dir)
      ar_dir
    end
  end

  # list of files to include absolute or relative to RAILS_ROOT
  # an expression sent to Dir.glob is ok
  # FILE=config/ar_test_runner_init.rb,model/*.rb
  #
  # Create a file like ar_test_runner_init.rb and include custom files
  #   require 'mygem'
  #   require '../../blah.rb'
  def expanded_files
    @expanded_files ||= split_file_names('FILE').inject([]) do |files, file|
      files.concat Dir.glob(file)
      files
    end
  end
  
  # list of comma delimited plugins (relative to RAILS_ROOT) to include
  #  PLUGIN=smsonrails
  def plugins
    @plugins ||= split_file_names 'PLUGIN' do |p| 
      File.join('vendor/plugins', p, 'init.rb')
    end
  end
  
  # list of strings to require. Similar to FILES but
  # does not expand the path. Use with gems
  #   REQUIRE=mygem/gem, gemsuper
  def requires
    @requires ||= split_input 'REQUIRE'
  end
  # list of file names and dirs to skip over
  def skipped_files
    @skipped_files ||= split_input 'SKIP'
  end

  # Gather the default files
  def default_app_files
    @default_app_files ||= REQUIRE_ALL_GLOB.inject([]) do |list, files| 
      list.concat Dir.glob(files).collect{ |f| File.expand_path(f) }
      list
    end
  end
  
  # update orig_files to skip the files we want to exclude
  # Note: this is not the best way. Loads this under the context of 
  # the activerecord version of the app
  def skip_files!(orig_files)
    return orig_files if skipped_files.blank? && !use_all_app_files? 

    #include activerecord
    require File.join(activerecord_dir, 'lib', 'activerecord.rb')

    #load each file now to see if it fails.
    orig_files.collect! { |f| require_file?(f) ? f : nil }.compact!
  end
  
  def use_all_app_files?
    ENV['APP'] || (plugins.blank? && requires.blank? && expanded_files.blank?)
  end
  
  protected
  
  # Return true if the file should be required.
  # The file is not skipped and can be loaded (required now)
  def require_file?(file_name)
    return false if skip_file?(file_name)
    require file_name unless skip_validation?
    true
  rescue NameError => exc
    error_and_exit(exc.to_s) unless exc.to_s == 'uninitialized constant ActionController'
    @auto_skip ||= []
    @auto_skip << file_name
    false
  end

  # Skip the file if it matches skipped_files (SKIP)
  def skip_file?(file_name)
    skipped_files.detect {|sf| file_name =~ Regexp.new("/#{sf}($|/)") }
  end
  
  def skip_validation?
    ENV['SKIP_VALIDATION'] == 'true'
  end
  
  #splite the comma delimited input
  def split_input(parameter, &block)
    args = ENV[parameter] ? ENV[parameter].split(/,\s*/) : []
    args.collect!{|a| yield a } if block
    args
  end
  
  #split the comma delimited input into expanded file names
  def split_file_names(parameter, &block)
    split_input(parameter) do |f|
      f = yield f if block
      error_and_exit("File does not exist: #{f}") unless File.exists?(f)
      File.expand_path f
    end
  end
  
  # Print the error and exit
  def error_and_exit(msg)
    STDERR.puts "ERROR: #{msg}"
    exit
  end

  def print_list(msg, file_list)
    STDOUT.puts "#{msg}:\n  #{ [file_list].flatten.join("\n  ") }" unless file_list.blank?
  end
  
  def print_info
    print_list 'Adapter', adapter
    print_list 'ActiveRecord Directory', activerecord_dir
    print_list 'Loaded Files', required_files
    print_list 'Skipped Files', skipped_files
    print_list 'Automatically Skipped Files (references ActionController)', auto_skip
  end
end