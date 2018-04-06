<template lang="pug">
  section.new_post
    .container
      input#post_title(
        ref="post_title"
        type="text"
        autofocus
        placeholder="Title (optional)"
        v-model="post.title"
        @keydown.enter.prevent="moveToBodyStart"
        @keydown.arrow-down.prevent="moveToBody"
      )

      textarea#post_body(
        ref="post_body"
        placeholder="Post body (Markdown enabled!)"
        v-model="post.body"
        @keydown.arrow-up="moveToTitle"
      )

      button(@click="submitForm") Create Post!
</template>

<script lang="coffee">
  newPost = ->
    title: ""
    body: ""

  focusAt = (el, pos) ->
    el.focus()
    el.selectionStart = pos
    el.selectionEnd = pos

  export default
    data: ->
      post: newPost()

    methods:
      moveToBody: ->
        focusAt @$refs.post_body, @$refs.post_title.selectionStart

      moveToBodyStart: ->
        focusAt @$refs.post_body, 0

      moveToTitle: ->
        pos = @$refs.post_body.selectionStart
        value = @$refs.post_body.value.substring 0, pos

        unless value.includes "\n"
          focusAt @$refs.post_title, pos
          event.preventDefault()

      submitForm: ->
        @$store.dispatch 'createPost', @post
          .then (res) =>
            @resetForm()
            @$refs.post_title.focus()
          .catch (e) =>
            console.log "ERROR: Post could not be created (#{e.response.data.message})"
            alert "Your post could not be saved. The server said: #{e.response.data.message}"


      resetForm: ->
        @post = newPost()
</script>
