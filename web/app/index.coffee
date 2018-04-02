import Vue from 'vue'
import App from './App'
import Router from './router'

document.addEventListener 'DOMContentLoaded', ->
  new Vue
    el: '#app',
    router: Router,
    render: (h) -> h(App)
