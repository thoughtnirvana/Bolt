# 
#  build.rb
#  bolt
#  
#  Created by Ben McRedmond on 2010-01-08.
#  Copyright 2010 Ben McRedmond. All rights reserved.
# 

require 'yaml'
require 'FileUtils'
require 'bolt/base'

module Bolt
  class Build < Base
    # Performs all the nessecary steps to build a Bolt project
    def run
      create_directory("out", :error_if_exists => false)
      copy_resouces
      parse_config
      load_pages
    end
    
    # Copies the contents of @config.resources to the out directory
    def copy_resources
      FileUtils.cp_r(@options.resources, @options.out)
    end
    
    # Parses @options.config and loads all contents into instance variables
    def parse_config
      config = YAML::load(open_file(@options.config))
      config.each do |key, value|
        self.instance_variable_set("@#{key}", value)
      end
    end  
    
    def load_pages
      @options.pages
    end      
  end
end