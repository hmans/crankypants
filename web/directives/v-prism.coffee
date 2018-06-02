import Vue from "vue"

import Prism from "@/lib/loadPrism"
import 'prismjs/themes/prism-okaidia.css'

Vue.directive "prism",
  deep: true

  bind: (el, binding) ->
    targets = el.querySelectorAll("code")

    for target in targets
      if binding.value
        target.textContent = binding.value

      Prism.highlightElement(target)

  componentUpdated: (el, binding) ->
    targets = el.querySelectorAll("code")

    for target in targets
      if binding.value
        target.textContent = binding.value
        Prism.highlightElement(target)
