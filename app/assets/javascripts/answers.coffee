# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  App.answers_subscribe = App.cable.subscriptions.create 'AnswersChannel',
    connected: ->
      subscribe_to_stream()

    received: (info) ->
      controller(info)

subscribe_to_stream = ->
  current_page = document.location.pathname
  question_id = $('.question').data('id')

  if current_page = '/questions/' + question_id
    App.answers_subscribe.perform 'follow', id: question_id
  else if current_page = '/'
    App.answers_subscribe.perform 'unfollow'

controller = (info) ->
  response = $.parseJSON(info)
  new_answer(response.publish) if response.publish
  update_answer(response.update) if response.update
  destroy_answer(response.destroy) if response.destroy

# call to edit answer form by click on edit button
edit_answer_call = ->
  # edit answer form created dynamically
  $('.exists_answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()

    # catching current fired edit form answer id
    if $('form.edit_answer').data('id')
      previous_answer_id = $('form.edit_answer').data('id')
    # all visible forms are hidden to prevent errors
    $('.edit_form').remove()
    # links to edit forms, body and update time on previous
    # answer are visible
    $('.edit-answer-link').show()
    $(".body_of_" + previous_answer_id).show();
    $(".updated_for_" + previous_answer_id).show();

    # current answer edit link hide
    $(this).hide()
    answer_id = $(this).data('answerId')
    answer_body = $(".body_of_" + answer_id)[0].innerText
    $(".body_of_" + answer_id).hide();
    $(".updated_for_" + answer_id).hide();
    edit_form = JST["templates/edit_form"]({answer_id: answer_id, answer_body: answer_body})
    $(edit_form).insertAfter("#editing_errors_" + answer_id).show()

update_answer = (response) ->
  # after editing answer, form is hiding, and the rest is showing
  answer = response.answer
  datetime = response.datetime
  $('.body_of_' + answer.id).html(answer.body).show();
  $('.updated_for_' + answer.id).html("изм. " + datetime).show();

new_answer = (response) ->
  row_template = JST["templates/new_answer_row_template"]({
    answer: response.answer,
    author: response.author,
    datetime: response.datetime
    })
  $(row_template).insertAfter('.exists_answers>div:last')
  # attaches added to answer
  attaches = JST["templates/attaches"]({ attaches: response.attaches })
  $(attaches).insertAfter('.body_of_' + response.answer.id)

best_answer_toggle = ->
  # best answer toggle
  $('.best').insertBefore('.exists_answers>div:first')
  $('.now-best').hide();
  $('.best').find('.answer_body').css('font-weight','bold');

  # file attaches delete
  $('.delete_answer_attach')
    .bind 'ajax:success', (e, data, status, xhr) ->
      attach = $.parseJSON(xhr.responseText)
      $('#file_'+attach.id).hide()

destroy_answer = (response) ->
  $('.answer_' + response.answer.id).remove()

$(document).on 'turbolinks:load', () ->
  subscribe_to_stream()
  best_answer_toggle()
  edit_answer_call()
  # destroy_answer()
