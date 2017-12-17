# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

creating_question = =>
  $('.ask_question').on 'click', (e) ->
    e.preventDefault()
    $(this).hide()
    # old errors messages removed
    $('#errors_alert').remove()
    $('.new_question').show()

    #new question form show
    $('form#new_question').on 'click', '.create_question', (e) ->
      $('form#new_question')
        .bind 'ajax:success', (e, data, status, xhr) ->
          $('#errors_alert').remove()
          question = $.parseJSON(xhr.responseText)
          new_question = JST["templates/new_question_template"] ({ question: question })
          $('.exists_questions>tbody:last').append(new_question)
          # form hidding
          $('form#new_question')[0].reset()
          $('.new_question').hide()
          #link to new question form showed
          $('.ask_question').show()

        .bind 'ajax:error', (e, xhr, status, error) ->
          $('#errors_alert').remove()
          response = $.parseJSON(xhr.responseText)
          if response.title && response.errors
            errors = JST["templates/errors"]({ title: response.title, errors: response.errors })
          else
            errors = JST["templates/authentication_error"]({ error: response.error })
          $(errors).insertAfter('.new_question_form')

    # 'cancel creating question' button actions
    $('.cancel').click (cancel) ->
      cancel.preventDefault()
      $('#errors_alert').remove()
      $('.new_question').hide()
      $('.ask_question').show()

stady = ->
  $('.edit_question_link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('.question').hide()
    $('.edit_question_form').show()

delete_question = ->
  $('.exists_questions').on 'click', '.delete_question', (e) ->
    $('.exists_questions')
      .bind 'ajax:success', (e, data, status, xhr) ->
        question = $.parseJSON(xhr.responseText)
        $('.question_' + question.id).remove()

      .bind 'ajax:error', (e, xhr, status, error) ->
        response = $.parseJSON(xhr.responseText)
        errors = JST["templates/permission_errors"]({ alert: response.alert })
        $(errors).insertBefore('.exists_questions')

$(document).on 'turbolinks:load', () ->
  creating_question();
  stady();
  delete_question();
