# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# vote = ->
#   $('body').on 'click', '.vote', (e) ->
#     $(this)
#       .bind 'ajax:success', (e, data, status, xhr) ->
#         respond = $.parseJSON(xhr.responseText)
#
#         object = respond.object
#         object_type = respond.object_type.toLowerCase()
#
#         $("." + object_type + "_votes_count_" + object.id)[0].innerText =
#           object.votes_count
#
# $(document).on 'turbolinks:load', () ->
#   $(vote)
