require "site_prism"

class Blog < SitePrism::Page
  set_url '/'
  element :site_title, 'header[role="main"] h1'
end

class App < SitePrism::Page
  set_url '/app'
  element :new_post_body, 'textarea#post_body'
end

# class Home < SitePrism::Page
#   set_url '/'
#   set_url_matcher /google.com\/?/
#
#   element :search_field, 'input[name="q"]'
#   element :search_button, "button[name='btnK']"
#   elements :footer_links, '#footer a'
#   section :menu, MenuSection, '#gbx3'
# end
#
