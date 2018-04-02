<template lang="pug">
  #app
    navigation
    router-view
</template>

<script lang="coffee">
  import { Blog, Navigation } from './components'

  export default
    name: 'app'
    components: { Blog, Navigation }
    created: ->
      @$store.dispatch 'loadPosts'
</script>
