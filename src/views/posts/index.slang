h1 Blog

form action="/posts" method="post"
  .input
    input id="post_title" type="text" name="post[title]" placeholder="Title (optional)" autofocus="true"
  .input
    textarea id="post_body" name="post[body]" placeholder="Post body (Markdown enabled!)"
  input type="submit" value="Create Post"

- posts.each do |post|
  p
    a href="/posts/#{post.id}" = post.title
