import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

export default new Vuex.Store
  state:
    posts: []

  mutations:
    set_posts: (state, posts) -> state.posts = posts
    remove_post: (state, post) ->
      p = state.posts
      p.splice p.indexOf(post), 1

  actions:
    loadPosts: ({ commit }) ->
      axios.get '/api/posts'
        .then (res) -> res.data
        .then (posts) -> commit 'set_posts', posts

    deletePost: ({ commit }, post) ->
      axios.delete "/api/posts/#{post.id}"
        .then -> commit 'remove_post', post
