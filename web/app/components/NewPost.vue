<template lang="pug">
  div.new_post
    .container
      input(type="text" autofocus v-model="post.title" placeholder="Title (optional)")
      textarea(v-model="post.body" placeholder="Post body (Markdown enabled!)")
      button(@click="submitForm") Create Post!
</template>

<script lang="coffee">
  newPost = ->
    title: ""
    body: ""

  export default
    data: ->
      post: newPost()

    methods:
      submitForm: ->
        @$store.dispatch 'createPost', @post
          .then (res) =>
            @resetForm()
          .catch (e) =>
            console.log "ERROR: Post could not be created (#{e.response.data.message})"
            alert "Your post could not be saved. The server said: #{e.response.data.message}"

      resetForm: ->
        @post = newPost()
</script>
