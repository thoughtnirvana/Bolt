# 
#  build.rb
#  bolt
#  
#  Created by Ben McRedmond on 2010-01-08.
#  Copyright 2010 Ben McRedmond. All rights reserved.
# 

require 'yaml'
require 'fileutils'

require 'bolt/base'
require 'bolt/page'
require 'bolt/view'

module Bolt
  class Build < Base
    # Performs all the nessecary steps to build a Bolt project
    def run
      remove_directory("out")
      create_directory("out", :error_if_exists => false)      
      copy_resources
      parse_config
      load_pages
    end
    
    # Copies the contents of $config.resources to the out directory
    def copy_resources
      FileUtils.cp_r(Dir.glob("#{d($config.resources)}/*"), d($config.out))
      puts "Copied #{d($config.resources)} to #{d($config.out)}"
    end
    
    # Parses $config.config and loads all contents into instance variables
    def parse_config
      $config_file = YAML::load(open_file(d($config.config)))
      puts "Parsed config #{d($config.config)}"
    end  
    
    def load_pages
      pages = Dir.glob("#{d($config.pages)}/*.rb")
      pages.each do |page|
        parse_page page        
      end
    end
    
    def parse_page(page)
      puts "Parsing page #{page}"
      load page      
    end
  end
end