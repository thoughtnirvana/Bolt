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

    def run
      parse_options
      run_command
    end

    def run_command
      self.send(@options.command)
    end

    def create
      require 'bolt/project'
      Project.new(@options.directory).run
    end

    def build
      require 'bolt/build'
      Build.new(@options.directory).run
    end

    def parse_options
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: bolt {create/build} [options] [file]"

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
        @options.directory = (ARGV.count == 2) ? ARGV[1] : "."
      end
    end
  end
end