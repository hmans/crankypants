<template lang="pug">
  section
    .container
      post-form(
        ref="post_form"
        :post="post"
        @submit="saveNewPost")
</template>

<script lang="coffee">
  import PostForm from './PostForm'

  newPost = ->
    title: ""
    body: ""

  focusAt = (el, pos) ->
    el.focus()
    el.selectionStart = pos
    el.selectionEnd = pos

  export default
    components:
      { PostForm }

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

      saveNewPost: ->
        @$store.dispatch 'createPost', @post
          .then (res) =>
            @post = newPost()
            # FIXME: the following probably is an extreme antipattern?
            @$refs.post_form.$refs.title.focus()
          .catch (e) =>
            console.log "ERROR: Post could not be created (#{e.response.data.message})"
            alert "Your post could not be saved. The server said: #{e.response.data.message}"
</script>
