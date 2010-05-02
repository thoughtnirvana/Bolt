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
    
    def initialize
      @default_directories = [$config.pages, $config.views, $config.lib, $config.resources] 
      @default_files = {$config.config => "default_files/config.yml", "#{$config.views}/application.haml" => "default_files/application.haml", "#{$config.views}/home.haml" => "default_files/home.haml", "#{$config.pages}/home.rb" => "default_files/home.rb"}
    end

    # Creates all nessecary directories and files for a new Bolt Project
    def run
      create_directory_structure
      create_files
    end
    
    private
    # Creates all the default directories using either defaults 
    # specified in lib/bolt.rb or by options on the command line
    def create_directory_structure
      create_directory($config.base_dir, :base_dir => true) unless File.directory?($config.base_dir)
      @default_directories.each {|directory| create_directory(directory)}
    end    
    
    # Creates all the default files using either defaults specified
    # in lib/bolt.rb or by options on the command line
    def create_files
      @default_files.each {|file, template| create_file(file, :copy_from => $BOLT_BASE + template)}
    end
  end
end