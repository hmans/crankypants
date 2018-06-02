# Entrypoint for Crankypants' management app.

import Vue from 'vue'

# add some CSS we want
import 'normalize.css'
import '@/directives/v-prism'

# Require the bits and pieces that form our app
import App from '@/components/App'
import store from '@/store'
import router from '@/router'

# CSS
import "@/styles/app.scss"

new Vue
  el: '#app'
  store: store
  router: router
  render: (h) -> h(App)
