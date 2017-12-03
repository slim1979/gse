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
  $('.ask_question').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('.new_question').show()
    $('form.new_question').on 'click', '.create_question', (e) ->
      $('form.new_question')
        .bind 'ajax:success', (e, data, status, xhr) ->
          question = $.parseJSON(xhr.responseText)
          new_question = JST["templates/new_question"] ({ question: question })
          $('.exists_questions > tbody:last').append(new_question)
          $('.new_question').hide()
          $('.ask_question').show()

        .bind 'ajax:error', (e, xhr, status, error) ->
          $('#errors_alert').remove()
          response = $.parseJSON(xhr.responseText)
          errors = JST["templates/errors"]({ title: response.title, resourse_id: response.resource.id, errors: response.errors })
          $(errors).insertBefore('form.new_question')

delete_question = =>
  $('.exists_questions').on 'click', '.delete_question', (e) ->
    console.log 212121
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
