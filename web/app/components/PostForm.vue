<template lang="pug">
  .post-form(@keydown.meta.enter.prevent="$emit('submit', fields)")
    input#post_title(
      ref="title"
      type="text"
      autofocus
      placeholder="Title (optional)"
      v-model="fields.title"
      @keydown.enter.prevent="moveToBodyStart"
      @keydown.arrow-down.prevent="moveToBody"
    )

    textarea#post_body(
      ref="body"
      placeholder="Post body (Markdown enabled!)"
      v-model="fields.body"
      @keydown.arrow-up="moveToTitle"
    )

    button(@click.prevent="$emit('submit', fields)") Save Post
    template(v-if="cancel")
      |  or
      |
      a(@click.prevent="$emit('cancel')" href='#') cancel
</template>

<script lang="coffee">
  focusAt = (el, pos = 0) ->
    el.focus()
    el.selectionStart = pos
    el.selectionEnd = pos

  export default
    props:
      title:
        type: String
        default: ""
      body:
        type: String
        default: ""
      cancel:
        required: false
        default: false

    data: ->
      fields:
        title: @title
        body: @body

    mounted: ->
      focusAt @$refs.title

    methods:
      clear: ->
        @fields.title = ""
        @fields.body = ""

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
</script>
