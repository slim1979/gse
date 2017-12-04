# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

stady = ->
  $('.edit_question_link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('.question').hide()
    $('.edit_question_form').show()

new_question = ->
  $('html').on 'click', '.ask_question', (e) ->
    e.preventDefault()
    $('.new_question').remove()
    $(this).hide()
    new_question_form = JST["templates/new_question_form"]({})
    $(new_question_form).insertBefore('.exists_questions')
    $('form.new_question').on 'click', '.create_question', (e) ->
      $('form.new_question')
        .bind 'ajax:success', (e, data, status, xhr) ->
          $('#errors_alert').remove()
          question = $.parseJSON(xhr.responseText)
          new_question = JST["templates/new_question_template"] ({ question: question })
          $('.exists_questions > tbody:last').append(new_question)
          $('.new_question').remove()
          $('.ask_question').show()

        .bind 'ajax:error', (e, xhr, status, error) ->
          $('#errors_alert').remove()
          response = $.parseJSON(xhr.responseText)
          errors = JST["templates/errors"]({ title: response.title, resourse_id: response.resource.id, errors: response.errors })
          $(errors).insertBefore('form.new_question')
    # 'cancel creating question' button actions
    $('.cancel_create_question').click (cancel) ->
      cancel.preventDefault()
      $('.new_question').remove()
      $('.ask_question').show()

delete_question = ->
  $('.exists_questions').on 'click', '.delete_question', (e) ->
    $('.exists_questions')
      .bind 'ajax:success', (e, data, status, xhr) ->
        question = $.parseJSON(xhr.responseText)
        $('.question_' + question.id).hide()

      .bind 'ajax:error', (e, xhr, status, error) ->
        response = $.parseJSON(xhr.responseText)
        errors = JST["templates/permission_errors"]({ alert: response.alert })
        $(errors).insertBefore('.exists_questions')

$(document).on 'turbolinks:load', () ->
  $(stady)
  $(new_question)
  $(delete_question)
