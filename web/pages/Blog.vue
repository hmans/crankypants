<template lang="pug">
  #blog
    new-post
    post(v-for="post in latestPosts" :key="post.id" :post="post")
</template>

<script lang="coffee">
  import { mapGetters } from 'vuex'
  import { Post, NewPost } from '../components'

  export default
    components: { Post, NewPost }
    computed:
      mapGetters ['latestPosts']
</script>
