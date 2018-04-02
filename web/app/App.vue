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
</script>

<style lang="scss">
@import url('https://fonts.googleapis.com/css?family=Open+Sans:400,400i,700');

* { box-sizing: inherit }
html, body { box-sizing: border-box; }

body {
  background-color: #f2f2f2;
  font: 15px/1.5 "Open Sans", Helvetica, sans-serif;
}

nav[role="main"] {
  background-color: rgb(245, 196, 95);
}

.container {
  max-width: 800px;
  padding: 0.5em;
}

</style>
