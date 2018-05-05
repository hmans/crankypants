import Vue from 'vue'

# add some CSS we want
import 'normalize.css'
import './v-prism'

# Require the bits and pieces that form our app
import App from './App'
import store from './store'
import router from './router'
import './app.scss'

new Vue
  el: '#app'
  store: store
  router: router
  render: (h) -> h(App)
