ar_dir_name = File.basename(ENV['AR_DIR'])

# If we are inside a gem, activesupport is located back a directory
  # with the version name. Add this to the LOAD_PATH
  # Example: ../activesupport-2.3.2
if (match = ar_dir_name.match(/activerecord-([\d\.]*)$/)) && match[1]
  ext = match[1]
  dirs = %w(active_support active_record).each do |f|
    dir = f.gsub('_', '') + '-' + ext
    $LOAD_PATH << File.join(ENV['AR_DIR'], '..', dir , 'lib')
    file = File.join(ENV['AR_DIR'], '..', dir , 'lib', f)
    #require file
  end
end
  
#always require active_record
require 'active_record'
