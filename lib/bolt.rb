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
      @options = OpenStruct.new
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
      self.send(@options.command)
    end
    
    # Creates a new project object and runs it resulting in creating 
    # all nessecary directories for a new bolt project
    def create
      require 'bolt/project'
      Project.new(@options).run
    end

    # Creates a new build object and runs it resulting in building
    # a bolt project and saving all files into the "out" directory.
    def build
      require 'bolt/build'
      Build.new(@options).run
    end

    # Parses command line options
    def parse_options
      @options.resources = "resources"
      @options.lib = "lib"
      @options.views = "views"
      @options.pages = "pages"
      @options.out = "out"
      @options.config = "config.yml"
      
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: bolt {create/build} [options] [file]"

        opts.on("-r", "--resources [resource-dir]", "Resources directory") do |opts|
          @options.resources = opts
        end
        
        opts.on("-v", "--views [views-dir]", "Views directory") do |opts|
          @options.views = opts
        end
        
        opts.on("-l", "--lib [lib-dir]", "Library directory") do |opts|
          @options.lib = opts
        end
        
        opts.on("-p", "--pages [pages-dir]", "Pages directory") do |opts|
          @options.pages = opts
        end

        opts.on("-o", "--out [out-directory]", "Where to save HTML") do |opts|
          @options.out = opts
        end
        
        opts.on("-c", "--config [config-file.yml]", "Config file") do |opts|
          @options.config = opts
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
        @options.command = ARGV[0]
        @options.base_dir = (ARGV.count == 2) ? ARGV[1] : "."
      end
    end
  end
end