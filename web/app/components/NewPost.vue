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
        @resetForm()

      resetForm: ->
        @post = newPost()
</script>
