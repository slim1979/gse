# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  App.questions_subscribe = App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      subscribeToQuestions()

    received: (data) ->
      $('#errors_alert').remove()
      controller(data)
      # response = $.parseJSON(data)
      # if response.publish
      # else if response.destroy
      #   question_id = response.destroy.question.id
      #   $('.question_' + question_id).remove()
  })

subscribeToQuestions = ->
  exists_questions = $('.exists_questions').data('list')
  if exists_questions
    App.questions_subscribe.perform 'follow'
  else
    App.questions_subscribe.perform 'unfollow'

controller = (data) ->
  response = $.parseJSON(data)
  if response.publish
    creating_question(response.publish)
  else if response.destroy
    destroy_question(response.destroy)

creating_question = (response) ->
  $('.ask_question').on 'click', (e) ->
    e.preventDefault()
    $(this).hide()
    # old errors messages removed
    $('#errors_alert').remove()
    $('.new_question').show()

publish_question = (response) ->
  #new question form show
  if response
    $('#errors_alert').remove()
    new_question = JST["templates/new_question_template"] ({ question: response.question, author: response.author})
    $('.exists_questions>tbody:last').append(new_question)
    # form hidding
    $('form#new_question')[0].reset()
    $('.new_question').off().hide()
    #link to new question form showed
    $('.ask_question').show()

        # .bind 'ajax:error', (e, xhr, status, error) ->
        #   $('#errors_alert').remove()
        #   response = $.parseJSON(xhr.responseText)
        #   if response.title && response.errors
        #     errors = JST["templates/errors"]({ title: response.title, errors: response.errors })
        #   else
        #     errors = JST["templates/authentication_error"]({ error: response.error })
        #   $(errors).insertAfter('.new_question_form')

    # 'cancel creating question' button actions
    $('.cancel').click (cancel) ->
      cancel.preventDefault()
      $('#errors_alert').remove()
      $('.new_question').hide()
      $('.ask_question').show()

edit_question = ->
  $('.edit_question_link').click (e) ->
    e.preventDefault()
    $(this).hide()
    console.log 'eidt'
    $('.question').hide()
    $('.edit_question_form').show().insertBefore('.exists_answers')

    $('.edit_question_form')
      .bind 'ajax:success', (e, data, status, xhr) ->
        $('#errors_alert').remove()
        question = $.parseJSON(xhr.responseText)
        $('.edit_question_form').hide()
        $('.question_errors').hide()
        $('.question').show()
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

destroy_question = ->
  $('.exists_questions').on 'click', '.delete_question', (e) ->
    $('.exists_questions')
      .bind 'ajax:error', (e, xhr, status, error) ->
        response = $.parseJSON(xhr.responseText)
        errors = JST["templates/permission_errors"]({ alert: response.alert })
        $(errors).insertBefore('.exists_questions')

$(document).on 'turbolinks:load', () ->
  subscribeToQuestions()
  creating_question()
  edit_question()
  destroy_question()
