# 
#  page.rb
#  bolt
#  
#  Created by Ben McRedmond on 2010-01-09.
#  Copyright 2010 Ben McRedmond. All rights reserved.
# 

# Loads the specified view into instance variable @content
# which is then inserted into a template
def render(view, options = {})
  raise ArgumentError, "Please specify a view to render" if view.empty?
  
  options[:template] ||= $config_file['primary_template']
  options[:engine] ||= "haml"

  raise ArgumentError, ":engine cannot be view" if options[:engine] == "view"    
  require options[:engine_require] || options[:engine]
  
  @content = render_view(view_as_string(view, options[:engine]), options[:engine])
  render_view(view_as_string(options[:template]), options[:engine]) unless options[:template].empty?
end

# Writes a file containing whatever is returned from a supplied block
# Will create directories as required by <tt>path</tt>
def page(path)
  @current_page = path
  create_path(path)
  
  path = "#{$config.base_dir}#{$config.out}/#{path}.html"
  File.open(path, 'w') {|f| f.write yield}
  puts "Created #{path}"
end

private
def create_path(path)
  path = path.split('/')
  if path.count > 1
    path = "#{$config.base_dir}#{$config.out}/#{path[0..path.length-2].join('/')}"
    if !File.directory?(path)
      FileUtils.mkdir_p(path)
      puts "Created #{path}"
    end
  end
end

# Opens a view file and attempts to read it into a string
def view_as_string(view, engine = "haml")
  v = ""
  path = "#{$config.base_dir}/#{$config.views}/#{view}"
  
  begin
    File.open(path) {|f| v = f.read}
  rescue Errno::ENOENT
    File.open("#{path}.#{engine}") {|f| v = f.read}
  end
  
  v
end

# Renders <tt>view</tt> with <tt>engine</tt>
def render_view(view, engine)
  self.send("render_#{engine}", view)
end

# Renders haml string, <tt>haml</tt>
def render_haml(haml, locals = {})
  if locals != false && locals.empty?
    self.instance_variables.each do |var|
      locals[var.split("@")[1]] = self.instance_variable_get(var)
    end
    
    locals.merge!($config_file)
  end
  
  Haml::Engine.new(haml).render(Object.new, locals)
end