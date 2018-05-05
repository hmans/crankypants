require "site_prism"

class Post < SitePrism::Section
  element :body, 'div.post-body'
end

class Blog < SitePrism::Page
  set_url '/'
  element :site_title, 'header[role="main"] h1'
  sections :posts, Post, 'article.post'
end

class App < SitePrism::Page
  set_url '/app'
  element :new_post_body, 'textarea#post_body'
end
