<template lang="pug">
  #blog
    post(v-for="post in posts" :key="post.id" :post="post")
</template>

<script lang="coffee">
  import { mapState, mapMutations } from 'vuex'
  import Post from './Post'

  export default
    components: { Post }
    computed:
      mapState ['posts']
    methods:
      mapMutations ['increment']
</script>
