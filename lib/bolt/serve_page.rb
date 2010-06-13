require 'drb'

DRb.start_service()
@serve_instance = DRbObject.new(nil, $drb_uri)

def page(path, &block)
  @current_page = path
  path = "" if path == "index"  
  @serve_instance.pages[path] = block
end