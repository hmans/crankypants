article.post
  .post-meta
    a href=post.url = post.created_at.not_nil!.to_s("%H:%M")
  .post-body
    h1 = post.title
    p == post.body_html
