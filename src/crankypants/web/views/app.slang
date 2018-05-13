doctype html
html
  head
    meta name="viewport" content="width=device-width,initial-scale=1.0"
    meta charset="utf-8"
    title Crankypants App
    link rel="stylesheet" type="text/css" href="#{Crankypants::Web::View.asset_url("app.css")}"
    script type="application/javascript" src="#{Crankypants::Web::View.asset_url("app-bundle.js")}" defer=true
  body
    #app
