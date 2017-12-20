# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      console.log 'Подключено'
      @perform 'follow'
    ,
    received: (data) ->
      $('#errors_alert').remove()
      response = $.parseJSON(data)
      if response.publish
        question = response.publish.question
        author = response.publish.author
        new_question = JST["templates/new_question_template"] ({ question: question, author: author})
        $('.exists_questions>tbody:last').append(new_question)
      else if response.destroy
        question_id = response.destroy.question.id
        $('.question_' + question_id).remove()
  })
creating_question = ->
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
          # form hidding
          $('form#new_question')[0].reset()
          $('.new_question').off().hide()
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
    console.log 'eidt'
    $('.question_attributes').hide()
    $('.edit_question_form').show().insertBefore('.exists_answers')

    $('.edit_question_form')
      .bind 'ajax:success', (e, data, status, xhr) ->
        $('#errors_alert').remove()
        question = $.parseJSON(xhr.responseText)
        $('.edit_question_form').hide()
        $('.question_errors').hide()
        $('.question_attributes').show()
        $('.edit_question_link').show()
        $('.question_title').html(question.title)
        $('.question_body').html(question.body)

      .bind 'ajax:error', (e, xhr, status, error) ->
        $('#errors_alert').remove()
        response = $.parseJSON(xhr.responseText)
        if response.title && response.errors
          errors = JST["templates/errors"]({ title: response.title, errors: response.errors })
        else
          errors = JST["templates/authentication_error"]({ error: response.error })
        $(errors).insertBefore('.edit_question_form')

delete_question = ->
  $('.exists_questions').on 'click', '.delete_question', (e) ->
    $('.exists_questions')
      .bind 'ajax:error', (e, xhr, status, error) ->
        response = $.parseJSON(xhr.responseText)
        errors = JST["templates/permission_errors"]({ alert: response.alert })
        $(errors).insertBefore('.exists_questions')

$(document).on 'turbolinks:load', () ->
  creating_question();
  stady();
  delete_question();
