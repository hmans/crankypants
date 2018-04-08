import axios from 'axios'

export default
  loadPosts: ({ commit }) ->
    axios.get '/api/posts'
      .then (res) -> res.data
      .then (posts) -> commit 'set_posts', posts

  deletePost: ({ commit }, post) ->
    axios.delete "/api/posts/#{post.id}"
      .then -> commit 'remove_post', post

  createPost: ({ commit }, post) ->
    axios.post '/api/posts', post
      .then (res) -> res.data
      .then (post) -> commit 'add_post', post

  updatePost: ({ commit }, { id, ...attrs }) ->
    axios.patch "/api/posts/#{id}", attrs
      .then (res) ->
        res.data
      .then (post) ->
        commit 'update_post', post
