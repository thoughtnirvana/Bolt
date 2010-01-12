# 
#  base.rb
#  bolt
#  
#  Created by Ben McRedmond on 2010-01-08.
#  Copyright 2010 Ben McRedmond. All rights reserved.
# 

require 'fileutils'
require 'ftools'

$BOLT_BASE = File.dirname(__FILE__) + "/../../"

module Bolt
  class Base
    # Takes an ostruct options object created by parsing ARGV
    def initialize(options)
      $config = options
      STDOUT.sync = true
    end        
    
    # Creates a directory, prefixes $config.base_dir if required
    def create_directory(directory, options = {})
      options[:error_if_exists] = (options[:error_if_exists].nil?) ? true : options[:error_if_exists]
      directory = directory
      
      if File.directory?(directory)
        raise ArgumentError, "#{directory} exists already." if options[:error_if_exists]
      else
        Dir.mkdir(directory)
        puts "Created #{directory}"
      end            
    end
    
    # Forces removal of directory, <tt>directory</tt>
    def remove_directory(directory)
      directory = directory
      FileUtils.rm_rf(directory)
      puts "Removed #{directory}"
    end
    
    # Creates a file, <tt>file</tt>, with the contents of <tt>:copy_from</tt>, prefixes $config.base_dir
    def create_file(file, options = {})
      file = d(file)
            
      options[:mode] ||= "r"
      options[:copy_from] ||= false
      
      if options[:copy_from]          
        f = File.copy(options[:copy_from], file)
      else
        f = File.new(file, options[:mode])
      end
    
      puts "Created #{file}"
    end
    
    # Opens file, <tt>file</tt> with mode, <tt>mode</tt> prefixes $config.base_dir
    def open_file(file, mode = "r")
      File.open(d(file), mode)
    end
    
    # Returns <tt>file_or_directory</tt> with $config.base_dir prefixed
    def d(file_or_directory)
      $config.base_dir + file_or_directory
    end
  end
end