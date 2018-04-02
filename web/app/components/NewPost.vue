<template lang="pug">
  section.new_post
    .container
      input#post_title(ref="post_title" type="text" autofocus v-model="post.title" placeholder="Title (optional)")
      textarea#post_body(v-model="post.body" placeholder="Post body (Markdown enabled!)")
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
            @$refs.post_title.focus()
          .catch (e) =>
            console.log "ERROR: Post could not be created (#{e.response.data.message})"
            alert "Your post could not be saved. The server said: #{e.response.data.message}"


      resetForm: ->
        @post = newPost()
</script>
