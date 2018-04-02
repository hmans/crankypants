<template>
  <div id="app">
    <h1>Hello World!</h1>
    <blog></blog>
  </div>
</template>

<script>
import Blog from './components/Blog.vue'

export default {
  name: 'app',
  components: {
    Blog
  }
}
</script>
