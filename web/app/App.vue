<template lang="pug">
  #app
    .container
      h1 Hello World
      
      p
        router-link(to='/app') BLOG
        router-link(to='/app/feed') FEED
        router-link(to='/app/network') NETWORK
      
      router-view
</template>

<script lang="coffee">
import Blog from './components'

export default
  name: 'app'
  components: { Blog }
</script>

<style lang="scss">
body {
  background-color: rgb(163, 172, 233);
}
</style>
