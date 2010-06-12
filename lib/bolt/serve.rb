# 
#  serve.rb
#  bolt
#  
#  Created by Ben McRedmond on 2010-06-06.
#  Copyright 2010 Ben McRedmond. All rights reserved.
# 

require 'socket'
require 'time'

require 'bolt/build'
require 'drb/drb'

module Bolt
  class DRbHash < Hash
    include DRbUndumped
  end
  
  class Serve < Build    
    attr_accessor :pages
  
    def initialize
      super
      @pages = DRbHash.new
      

      DRb.start_service(nil, self)
      $drb_uri = DRb.uri
      
      @server = HTTPServer.new()
      
      trap("INT") { exit! }
    end
  
    def run
      # This has to be loaded after the DRb server is started above
      load 'bolt/serve_page.rb'
      
      begin
        while(request = @server.listen)
          # Bit of magic here (eek)
          # Basically the parent class Build loads each page in the pages directory
          # for whatever project we're in, however the bolt/serve_page require up above
          # overrides the standard page method used in these pages to instead send us 
          # the block used to generate the page, so basically @pages is full of 
          # url => block references.
          load_pages        
          parse_config
        
          page = @pages[request['GET'].gsub(/\.html/,'')[1..-1]]
        
          if(!page.nil?)
            @server.reply(page.call)
          else
            # Check files
          end
        end
      rescue Exception => e
        puts e
        @server.reply("error", 500)
        retry
      end
      
      DRb.thread.join
    end
  
  end
  
  class HTTPServer  
    def initialize(options={})
      options[:host] ||= '127.0.0.1'
      options[:port] ||= '2658'

      @server = TCPServer.new(options[:host], options[:port])
      puts "## Starting BoltServe on http://#{options[:host]}:#{options[:port]} ## \n\n"
    end

    def listen()
      @session = @server.accept
      @request = {}
      @request['headers'] = {}

      while(header = @session.gets)
        if(header == "\r\n")
          break
        elsif(!header.scan(/GET .* HTTP.*/).empty?)
          @request['GET'] = header.gsub(/GET /, '').gsub(/ HTTP.*/, '').strip
        else
          h = header.split(':')
          @request['headers'][h[0]] = h[1].strip unless h[1].nil?
        end
      end

      puts "Request from: #{@session.addr[2]} \n\tfor #{@request['GET']}\n\n"
      @request
    end

    def reply(body, status = '200', headers={})
      headers['Content-Length'] ||= body.length
      headers['Connection'] ||= 'close'
      headers['Date'] ||= Time.now.getgm
      headers['Last-Modified'] ||= headers['Date']    
      headers['Content-Type'] ||= 'text/html; charset=UTF-8'

      headers['Server'] = 'Bolt Development Server'

      @session.print("HTTP/1.1 #{status}\n")
      headers.each do |header, value|
        @session.print("#{header}: #{value}\n")
      end

      @session.print("\n")    
      @session.print(body)
      @session.print("\r\n")

      @session.close()
    end
  end
end