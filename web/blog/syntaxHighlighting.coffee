import Prism from "../shared/loadPrism"
import 'prismjs/themes/prism-okaidia.css'

document.addEventListener "turbolinks:load", ->
  Prism.highlightAll()
