<template lang="pug">
  #blog
    new-post
    post(v-for="post in posts" :key="post.id" :post="post")
</template>

<script lang="coffee">
  import { mapState, mapMutations } from 'vuex'
  import Post from './Post'
  import NewPost from './NewPost'

  export default
    components: { Post, NewPost }
    computed:
      mapState ['posts']
    methods:
      mapMutations ['increment']
</script>
