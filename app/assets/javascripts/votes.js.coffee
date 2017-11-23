# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

vote = ->
  $('.vote')
    .bind 'ajax:success', (e, data, status, xhr) ->

      respond = $.parseJSON(xhr.responseText)

      vote = respond.vote
      subject_type = vote.subject_type.toLowerCase()
      subject_id = vote.subject_id

      current_subject_votes_count = respond.current_subject_votes_count

      $("." + subject_type + "_votes_count_" + subject_id)[0].innerText =
        current_subject_votes_count

$(document).on 'turbolinks:load', () ->
  $(vote)
