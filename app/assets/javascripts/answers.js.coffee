# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# edit answer form created dynamically
edit = ->
  # edit answer form created dynamically
  # $('.edit-answer-link').click (e) ->
  $('.exists_answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()

    # catching current fired edit form answer id
    if $('.edit_answer').data('id')
      previous_answer_id = $('.edit_answer').data('id')
    # all visible forms are hidden to prevent errors
    $('.edit_form_' + previous_answer_id).remove()
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
        answer = $.parseJSON(xhr.responseText)
        $('.edit_form_'+answer.id).remove();
        $('.body_of_' + answer.id).html(answer.body).show();
        $('.updated_for_' + answer.id).html(answer.updated_at).show();
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

ready = ->
  # best answer toggle
  $('.best').insertBefore('tr:first');
  $('.now-best').hide();
  $('tr.best').find('.answer_body').css('font-weight','bold');
  $('.img').hide();
  $('.thumbs-up').show();

  # answer create form events
  $('form#new_answer')
    # ajax success when valid answer created
    .bind 'ajax:success', (e, data, status, xhr) ->
      response = $.parseJSON(xhr.responseText)
      # row template appended to page
      answer = response.answer
      row_template = JST["templates/new_answer_row_template"]({ answer: answer })
      $('.answers-table > tbody:last').append(row_template)
      # attaches added to answer
      attaches = JST["templates/attaches"]({ attaches: response.attaches })
      $(attaches).insertAfter('.updated_for_'+response.answer.id)
      # clean up form text after creating answer
      $('.new_answer_body').val('');
      $('input').val('');
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

destroy_answer = ->
  $('.delete_answer')
    .bind 'ajax:success', (e, data, status, xhr) ->
      response = $.parseJSON(xhr.responseText)
      $('#answer_' + response.id).remove()

$(document).on 'turbolinks:load', () ->
  $(ready)
  $(edit)
  $(destroy_answer)
