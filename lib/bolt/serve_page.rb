require 'drb'

DRb.start_service()
@serve_instance = DRbObject.new(nil, $drb_uri)

def page(page, &block)
  page = "" if page == "index"
  @serve_instance.pages[page] = block
end