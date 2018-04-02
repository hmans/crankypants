<template lang="pug">
  #blog
    .container
      article.post(v-for="post in posts")
        header
          h2 {{ post.title }}
        .post-body(v-html="post.body")
</template>

<script lang="coffee">
  export default
    data: ->
      posts: [
        {
          id: 1
          title: "First Post!"
          body: "<p>This is the first blog post. Amazing!</p>"
        },
        {
          id: 2
          title: "Second Post!"
          body: "<p>Here's another post. Whoddathunk.</p>"
        }
      ]
</script>
