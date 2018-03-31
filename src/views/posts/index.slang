h1 Blog

form action="/posts" method="post"
  .input
    input type="text" name="post[title]"
  .input
    textarea name="post[body]"
  input type="submit" value="Create Post"

- posts.each do |post|
  p
    a href="/posts/#{post.id}" = post.title
