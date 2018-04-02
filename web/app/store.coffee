import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

export default new Vuex.Store
  state:
    posts: []

  mutations:
    set_posts: (state, posts) -> state.posts = posts

  actions:
    loadPosts: ({ commit }) ->
      axios
        .get '/api/posts'
        .then (res) -> res.data
        .then (posts) ->
          commit 'set_posts', posts
