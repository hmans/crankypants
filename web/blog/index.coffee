console.log "hi from blog!"

import "normalize.css"
import "highlightjs/styles/kimbie.light.css"
import "./blog.scss"

# Initialize Turbolinks
import Turbolinks from "turbolinks"
Turbolinks.start()

# hightlight.js
import hljs from "highlightjs"

# This function will be called every time a page is loaded.
initPage = ->
  hljs.initHighlighting.called = false
  hljs.initHighlighting()

document.addEventListener "turbolinks:load", initPage
