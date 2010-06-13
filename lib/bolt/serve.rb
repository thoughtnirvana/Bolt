# 
#  serve.rb
#  bolt
#  
#  Created by Ben McRedmond on 2010-06-06.
#  Copyright 2010 Ben McRedmond. All rights reserved.
# 

require 'socket'
require 'time'
require 'drb/drb'

require 'bolt/build'

class File
  def content_type
    mime = {'.jpeg'  => 'image/jpeg',        '.jpg'   => 'image/jpeg',
            '.png'   => 'image/png',         '.gif'   => 'image/gif',
            '.mp3'   => 'audio/mpeg3',       '.aif'   => 'audio/aiff',
            '.mid'   => 'audio/midi',        '.wav'   => 'audio/wav',
            '.m4a'   => 'audio/MP4A-LATM',   '.3gp'   => 'video/3gpp',
            '.dv'    => 'video/DV',          '.mp4'   => 'video/H264',
            '.pdf'   => 'application/pdf',   '.js'    => 'application/js',
            '.json'  => 'application/json',  '.xml'   => 'text/xml',
            '.html'  => 'text/html',         '.htm'   => 'text/htm',
            '.css'   => 'text/css',          '.txt'   => 'text/plain'}
    mime[File.extname(self.path)] || 'application/octet-stream'
  end
  
  def to_s
    s = ""
    self.each {|line| s += line}
    s
  end
end

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
      
      @server = HTTPServer.new(:host => $config.serve_host, :port => $config.serve_port)
      
      @errors_base = File.expand_path(File.dirname(File.dirname(__FILE__))) + '/bolt/serve_errors/'
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
          
          page_name = request['GET'].gsub(/\.html/,'')[1..-1]
          page = @pages[page_name]
        
          if(!page.nil?)
            @server.reply(page.call)
          elsif(File.exists?(d($config.resources) + request['GET']))
            f = File.new(d($config.resources) + request['GET'])            
            @server.reply(f.to_s, 200, 'Content-Type' => f.content_type)
          else
            @server.reply(File.new(@errors_base + '404.html').to_s, 404)
          end
        end
      rescue Exception => e
        puts e
        @server.reply(File.new(@errors_base + '500.html').to_s, 500)
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

      puts "Request from: #{@session.addr[2]} \n\tfor: #{@request['GET']}\n\n"
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