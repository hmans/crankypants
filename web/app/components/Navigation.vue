<template lang="pug">
  nav(role="main")
    .container
      ul
        li: router-link(to='/app') BLOG
        li: router-link(to='/app/feed') FEED
        li: router-link(to='/app/network') NETWORK
</template>
