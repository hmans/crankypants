import Vue from 'vue'
import Router from 'vue-router'

import { Blog, Feed, Network, EditPost } from './pages'

Vue.use(Router)

export default new Router
  mode: 'history'
  linkActiveClass: 'active'
  routes: [{
    path: '/app'
    name: 'blog'
    component: Blog
  }, {
    path: '/app/feed'
    name: 'feed'
    component: Feed
  }, {
    path: '/app/network'
    name: 'network'
    component: Network
  }]
