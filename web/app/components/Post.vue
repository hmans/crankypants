<template lang="pug">
  article.post
    .container
      h2(v-if="post.title") {{ post.title }}
      .post-body(v-html="post.body_html")
</template>

<script lang="coffee">
  export default
    props: ['post']
    methods:
      deletePost: ->
        if confirm 'Are you sure? There is no undo!'
          @$store.dispatch 'deletePost', @post
</script>
