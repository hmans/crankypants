<template lang="pug">
  article.post
    .container
      header
        h2 {{ post.title }}
      .post-body(v-html="post.body_html")
      button(v-on:click="deletePost") Delete
</template>

<script lang="coffee">
  export default
    props: ['post']
    methods:
      deletePost: ->
        if confirm 'Are you sure? There is no undo!'
          @$store.dispatch 'deletePost', @post
</script>

<style scoped>
  article.post {
    margin: 1em 0;
  }
  
  article.post>.container {
    background-color: white;
  }
</style>
