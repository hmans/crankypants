<template lang="pug">
  #app
    h1 Hello World
    blog
</template>

<script lang="coffee">
import Blog from './components/Blog.vue'

export default
  name: 'app'
  components: { Blog }
</script>
