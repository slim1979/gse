# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  App.answers_subscribe = App.cable.subscriptions.create 'AnswersChannel',
    connected: ->
      subscribe_to_stream()

    received: (info) ->
      little_controller(info)

subscribe_to_stream = ->
  question_id = $('.question').data('id')

  if question_id
     App.answers_subscribe.perform 'follow', id: question_id
  else
     App.answers_subscribe.perform 'unfollow'

little_controller = (info) ->
  response = $.parseJSON(info)
  if response.publish
    new_answer(response.publish)
  else if response.destroy
    destroy_answer(response.destroy)

edit_answer = ->
  # edit answer form created dynamically
  # $('.edit-answer-link').click (e) ->
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

    # after editing answer, form is hiding, and the rest is showing
    $('form.edit_answer')
      .bind 'ajax:success', (e, data, status, xhr) ->
        response = $.parseJSON(xhr.responseText)
        answer = response.answer
        datetime = response.datetime
        $('.edit_form_'+ answer.id).remove();
        $('.body_of_' + answer.id).html(answer.body).show();
        $('.updated_for_' + answer.id).html("изм. " + datetime).show();
        $('.edit_answer_' + answer.id).show();
        # clearing editing errors
        $('#errors_alert').empty().hide();

      .bind 'ajax:error', (e, xhr, status, error) ->
        # receiving response
        response = $.parseJSON(xhr.responseText)
        # making errors marked list with bootstrap style
        $('#errors_alert').remove()
        errors = JST["templates/errors"]({ title: response.title, resourse_id: response.resource.id, errors: response.errors })
        # insert list before edit form
        $(errors).insertBefore('#editing_errors_' + response.resource.id)

new_answer = (response) ->
  if response
    row_template = JST["templates/new_answer_row_template"]({
      answer: response.answer,
      author: response.author,
      datetime: response.datetime
      })
    $(row_template).insertAfter('.exists_answers>div:last')
    # attaches added to answer
    attaches = JST["templates/attaches"]({ attaches: response.attaches })
    $(attaches).insertAfter('.body_of_' + response.answer.id)

  # best answer toggle
  $('.best').insertBefore('.exists_answers>div:first')
  $('.now-best').hide();
  $('.best').find('.answer_body').css('font-weight','bold');

  # answer create form events
  $('form#new_answer')
    # ajax success when valid answer created
    .bind 'ajax:success', () ->
      # clean up form text after creating answer
      $('form#new_answer')[0].reset()
      # delete all loader files and create one
      $('.remove_nested_fields').click();
      $('.add_nested_fields').click();
      # errors cleared
      $('.alert').empty().hide()

    # ajax error when wrong answer created
    .bind 'ajax:error', (e, xhr, status, error) ->
      # clearing up old errors messages
      $('.answer_errors').empty().hide()
      # receiving respone
      response = $.parseJSON(xhr.responseText)
      # making errors marked list with bootstrap style
      errors = JST["templates/errors"]({title: response.title, resourse_id: response.resource.id, errors: response.errors })
      # insert list before new answer form
      $(errors).insertBefore('.new_answer')
  # file attaches delete
  $('.delete_answer_attach')
    .bind 'ajax:success', (e, data, status, xhr) ->
      attach = $.parseJSON(xhr.responseText)
      $('#file_'+attach.id).hide()

destroy_answer = (response) ->
  if response
    $('.answer_' + response.answer.id).remove()
        # .bind 'ajax:error', (e, xhr, status, error) ->
        #   $('.alert').remove()
        #   # response = $.parseJSON(xhr.responseText)
        #   error = JST['templates/authentication_error'] ({ error: response.alert })
        #   # $(error).insertBefore('.question')
        #   $('.exists_answers').prepend(error)

$(document).on 'turbolinks:load', () ->
  subscribe_to_stream()
  new_answer()
  edit_answer()
  destroy_answer()
