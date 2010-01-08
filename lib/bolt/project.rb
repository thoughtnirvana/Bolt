# 
#  project.rb
#  bolt
#  
#  Created by Ben McRedmond on 2010-01-08.
#  Copyright 2010 Ben McRedmond. All rights reserved.
# 

require 'bolt/base'

module Bolt
  class Project < Base
    @@default_directories = ["pages/", "views/", "lib/"]
    @@default_files = {"config.yml" => ""}
        
    def run
      create_directory_structure
      create_files
    end
    
    def create_directory_structure
      create_directory(@base_dir, true) unless File.directory?(@base_dir)
      @@default_directories.each {|directory| create_directory(directory)}
    end
    
    def create_directory(directory, base = false)
      directory = d(directory) unless base      
      
      if File.directory?(directory)
        raise ArgumentError, "#{directory} exists already."
      else
        Dir.mkdir(directory)
      end
      
      puts "Created #{directory}"
    end
    
    def create_files
      @@default_files.each {|file, contents| create_file(file, contents)}
    end
    
    def create_file(file, contents = "")
      file = d(file)
            
      begin
        f = File.new(file, "w")        
        f.puts(contents) unless contents.empty?
      ensure
        f.close unless f.nil?
      end
      
      puts "Created #{file}"
    end
  end
end