<template lang="pug">
  article.post
    .container
      header
        h2 {{ post.title }}
      .post-body(v-html="post.body_html")
</template>

<script lang="coffee">
  export default
    props: ['post']
</script>

<style scoped>
  article.post {
    margin: 1em 0;
  }
  
  article.post>.container {
    background-color: white;
  }
</style>
