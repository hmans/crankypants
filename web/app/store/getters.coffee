export default
  posts: (state) ->
    state.posts

  latestPosts: (state) ->
    state.posts.slice().sort (a, b) ->
      if a.created_at < b.created_at
        1
      else if a.created_at > b.created_at
        -1
      else 0

  post: (state) -> (id) ->
    state.posts.find (p) ->
      p.id == id
