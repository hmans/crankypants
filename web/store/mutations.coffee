import { removeFrom } from '@/lib/helpers'

export default
  set_posts: (state, posts) ->
    state.posts = posts

  remove_post: (state, post) ->
    ids = (p.id for p in state.posts)
    idx = ids.indexOf(post.id)
    state.posts.splice idx, 1

  add_post: (state, post) ->
    state.posts.push post

  update_post: (state, post) ->
    ids = (p.id for p in state.posts)
    idx = ids.indexOf(post.id)
    state.posts.splice idx, 1, post
