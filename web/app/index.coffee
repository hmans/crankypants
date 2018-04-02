import Vue from 'vue'

import "normalize.css"

import App from './App'
import store from './store'
import router from './router'

document.addEventListener 'DOMContentLoaded', ->
  new Vue
    el: '#app'
    store: store
    router: router
    render: (h) -> h(App)
