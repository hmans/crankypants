h1 Blog

- posts.each do |post|
  p
    a href="/posts/#{post.id}" = post.title
