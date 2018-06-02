<template lang="pug">
  #app
    navigation
    main
      router-view
</template>

<script lang="coffee">
  import Navigation from './Navigation'

  export default
    name: 'app'
    components: { Navigation }
    created: ->
      @$store.dispatch 'loadPosts'
</script>
