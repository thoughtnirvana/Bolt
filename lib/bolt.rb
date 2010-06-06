# 
#  bolt.rb
#  bolt
#  
#  Created by Ben McRedmond on 2010-01-08.
#  Copyright 2010 Ben McRedmond. All rights reserved.
# 

require 'optparse'
require 'ostruct'

module Bolt
  class Bolt
    def initialize
      $config = OpenStruct.new
      @commands = {"create" => true,
                   "build" => true}
    end
    
    # Parses command line options then runs the specified command
    def run
      parse_options
      run_command
    end
    
    private
    # Runs a command specified on the command line
    def run_command
      self.send($config.command)
    end
    
    # Creates a new project object and runs it resulting in creating 
    # all nessecary directories for a new bolt project
    def create
      require 'bolt/project'
      Project.new.run
    end

    # Creates a new build object and runs it resulting in building
    # a bolt project and saving all files into the "out" directory.
    def build
      require 'bolt/build'
      Build.new.run
    end
    
    def serve
      require 'bolt/serve'
      Serve.new.run
    end

    # Parses command line options
    def parse_options
      $config.resources = "resources"
      $config.lib = "lib"
      $config.views = "views"
      $config.out = "out"
      $config.pages = "pages"
      $config.config = "config.yml"
      
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: bolt {create/build} [options] [file]"

        opts.on("-r", "--resources [resource-dir]", "Resources directory") do |opts|
          $config.resources = opts
        end
        
        opts.on("-v", "--views [views-dir]", "Views directory") do |opts|
          $config.views = opts
        end
        
        opts.on("-l", "--lib [lib-dir]", "Library directory") do |opts|
          $config.lib = opts
        end
        
        opts.on("-p", "--pages [pages-dir]", "Pages directory") do |opts|
          $config.pages = opts
        end

        opts.on("-o", "--out [out-directory]", "Where to save HTML") do |opts|
          $config.out = opts
        end
        
        opts.on("-c", "--config [config-file.yml]", "Config file") do |opts|
          $config.config = opts
        end

        opts.on_tail("-h", "--help", "Show this help message") do
          puts opts
          exit        
        end

        opts.parse!(ARGV)  
      end

      if ARGV.empty? || ARGV.count > 2 || @commands[ARGV[0]].nil?
        puts opts.help
        exit
      else
        $config.command = ARGV[0]
        $config.base_dir = (ARGV.count == 2) ? ARGV[1] : "."
        $config.base_dir += '/' if $config.base_dir[-1..$config.base_dir.length] != '/'
      end
    end
  end
end
