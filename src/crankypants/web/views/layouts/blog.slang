doctype html
html
  head
    meta name="viewport" content="width=device-width,initial-scale=1.0"
    meta charset="utf-8"
    title = page_title
    link rel="stylesheet" type="text/css" href="/#{Crankypants::Web::ASSET_PATH}/blog.css"
    script type="application/javascript" src="/#{Crankypants::Web::ASSET_PATH}/blog-bundle.js" defer=true
  body
    header role="main"
      .container
        h1.site-title
          a href="/" = ENV.fetch("CRANKY_TITLE", "A Very Cranky Site")

    main
      .container
        == content

    footer role="main"
      .container
        p == "Served by <a href=\"https://github.com/hmans/crankypants\" target=\"_blank\">Crankypants</a> #{Crankypants::VERSION} (<a href=\"https://github.com/hmans/crankypants/commit/#{Crankypants::GIT_COMMIT}\" target=\"_blank\">#{Crankypants::GIT_COMMIT[0..6]}</a>)"
