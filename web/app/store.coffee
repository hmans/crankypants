import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store
  state:
    count: 0
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

  mutations:
    increment: (state) -> state.count++
