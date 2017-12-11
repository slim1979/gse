# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
delete_attach = ->
  $('body').on 'click', '.delete_attach', (e) ->
    e.preventDefault()
    $('body')
      .bind 'ajax:success', (e, data, status, xhr) ->
        response = $.parseJSON(xhr.responseText)
        $('#file_' + response.id).remove()

$(document).on 'turbolinks:load', ->
  $(delete_attach)
