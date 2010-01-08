# 
#  base.rb
#  bolt
#  
#  Created by Ben McRedmond on 2010-01-08.
#  Copyright 2010 Ben McRedmond. All rights reserved.
# 

module Bolt
  class Base
    def initialize(base_dir)
      @base_dir = "#{base_dir}/"
      STDOUT.sync = true
    end
  
    def d(file_or_directory)
      @base_dir + file_or_directory
    end
  end
end