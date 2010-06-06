require 'drb'

DRb.start_service()
serve_instance = DRbObject.new(nil, $drb_uri)

def page(page)
  serve_instance.pages[page] = Proc.new(yield)
end