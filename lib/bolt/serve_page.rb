require 'drb'

DRb.start_service()
@serve_instance = DRbObject.new(nil, $drb_uri)

def page(path, &block)
  path = "" if path == "index"
  @current_page = path
  @serve_instance.pages[path] = block
end