# 
#  serve.rb
#  bolt
#  
#  Created by Ben McRedmond on 2010-06-06.
#  Copyright 2010 Ben McRedmond. All rights reserved.
# 

require 'bolt/base'
require 'drb/drb'
require 'bolt/serve_page'

module Bolt
  class Serve < Build
    attr_accessor :pages
  
    def initialize
      super
      @pages = {}
      
      # Port is hardcoded atm, will need to be configurable
      $drb_uri = "druby://127.0.0.1:49765"
      DRb.start_service($drb_uri, self)      
    end
  
    def run
      load_pages
      
      DRb.thread.join
    end
  
  end
end