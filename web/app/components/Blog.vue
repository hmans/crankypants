<template lang="pug">
  #blog
    .container
      article.post(v-for="post in posts")
        header
          h2 {{ post.title }}
        .post-body(v-html="post.body_html")
</template>

<script lang="coffee">
  import { mapState, mapMutations } from 'vuex'

  export default
    computed:
      mapState ['posts']
    methods:
      mapMutations ['increment']
</script>
