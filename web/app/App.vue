<template lang="pug">
  #app
    navigation
    router-view
</template>

<script lang="coffee">
  import { Navigation } from './components'

  export default
    name: 'app'
    components: { Navigation }
    created: ->
      @$store.dispatch 'loadPosts'
</script>
