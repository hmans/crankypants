<template lang="pug">
  article.post
    .container
      post-form(
        ref="post_form"
        @submit="saveNewPost")
</template>

<script lang="coffee">
  import PostForm from './PostForm'

  export default
    components:
      { PostForm }

    methods:
      saveNewPost: ({ title, body })->
        @$store.dispatch 'createPost', { title, body }
          .then (res) =>
            @$refs.post_form.clear()
          .catch (e) =>
            console.log "ERROR: Post could not be created (#{e.response.data.message})"
            alert "Your post could not be saved. The server said: #{e.response.data.message}"
</script>
