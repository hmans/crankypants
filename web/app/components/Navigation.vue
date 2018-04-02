<template lang="pug">
  nav(role="main")
    .container
      ul
        li: router-link(to='/app') BLOG
        li: router-link(to='/app/feed') FEED
        li: router-link(to='/app/network') NETWORK
</template>

<style scoped>
  ul {
    list-style: none;
    padding-left: 0;
    margin: 0;
  }
  
  li {
    display: inline;
  }
  
  li+li {
    margin-left: 1em;
  }
</style>
