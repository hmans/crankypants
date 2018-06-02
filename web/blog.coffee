# Entrypoint for Crankypants' user-facing blog. Much lighter than its
# management app (see app.coffee.)

import "normalize.css"
import "@/styles/blog.scss"

# Yes, we use Turbolinks. Crankypants would already be crazy fast without it,
# but using Turbolinks also frees the browser from having to reevaluate all
# JSS and CSS on every request. It's mighty fine!
import Turbolinks from "turbolinks"
Turbolinks.start()

# Initialize syntax highlighting.
import Prism from "@/lib/loadPrism"
import 'prismjs/themes/prism-okaidia.css'

document.addEventListener "turbolinks:load", ->
  Prism.highlightAll()
