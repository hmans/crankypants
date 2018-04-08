import Vue from 'vue'

# add some CSS we want
import "normalize.css"
import 'highlightjs/styles/default.css'

# Enable v-highlightjs directive
import VueHighlightJS from 'vue-highlightjs'
Vue.use VueHighlightJS

# Require the bits and pieces that form our app
import App from './App'
import store from './store'
import router from './router'
import './app.scss'

document.addEventListener 'DOMContentLoaded', ->
  new Vue
    el: '#app'
    store: store
    router: router
    render: (h) -> h(App)
