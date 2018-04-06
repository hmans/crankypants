<template lang="pug">
  .post-form
    input#post_title(
      ref="title"
      type="text"
      autofocus
      placeholder="Title (optional)"
      v-model="post.title"
      @keydown.enter.prevent="moveToBodyStart"
      @keydown.arrow-down.prevent="moveToBody"
    )

    textarea#post_body(
      ref="body"
      placeholder="Post body (Markdown enabled!)"
      v-model="post.body"
      @keydown.arrow-up="moveToTitle"
    )

    button(@click="submitForm") Save!
</template>

<script lang="coffee">
  focusAt = (el, pos) ->
    el.focus()
    el.selectionStart = pos
    el.selectionEnd = pos

  export default
    props: ['post']

    methods:
      moveToBody: ->
        focusAt @$refs.body, @$refs.title.selectionStart

      moveToBodyStart: ->
        focusAt @$refs.body, 0

      moveToTitle: ->
        pos = @$refs.body.selectionStart
        value = @$refs.body.value.substring 0, pos

        unless value.includes "\n"
          focusAt @$refs.title, pos
          event.preventDefault()

      submitForm: ->
        @$emit 'submit'


      # submitForm: ->
      #   @$store.dispatch 'createPost', @post
      #     .then (res) =>
      #       @resetForm()
      #       @$refs.post_title.focus()
      #     .catch (e) =>
      #       console.log "ERROR: Post could not be created (#{e.response.data.message})"
      #       alert "Your post could not be saved. The server said: #{e.response.data.message}"
      #
      #
      # resetForm: ->
      #   @post = newPost()
</script>
