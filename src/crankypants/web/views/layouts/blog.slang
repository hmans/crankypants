doctype html
html
  head
    meta name="viewport" content="width=device-width,initial-scale=1.0"
    meta charset="utf-8"
    title = page_title
    link rel="stylesheet" type="text/css" href="/assets/blog.css"
    script type="application/javascript" src="/assets/blog-bundle.js" defer=true
  body
    .container
      h1.site-title
        a href="/" = ENV.fetch("CRANKY_TITLE", "A Very Cranky Site")
      == content
