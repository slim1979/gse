# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  App.questions_subscribe = App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      subscribeToQuestions()

    received: (data) ->
      controller(data)
  })

subscribeToQuestions = ->
  current_page = document.location.pathname
  question_id = $('.question').data('id')

  if current_page = '/'
    App.questions_subscribe.perform 'follow'
  else if current_page = '/questions/' + question_id
    App.questions_subscribe.perform 'question_update', id: question_id
  else
    App.questions_subscribe.perform 'unfollow'

controller = (data) ->
  $('#errors_alert').remove()
  response = $.parseJSON(data)
  if response.publish
    publish_question(response.publish)
  else if response.destroy
    destroy_question(response.destroy)
  else if response.update
    update_question(response.update)

call_creating_question = ->
  $('#errors_alert').remove()
  $('.ask_question').on 'click', (e) ->
    e.preventDefault()
    $(this).hide()
    # old errors messages removed
    $('.new_question').show()

    # 'cancel creating question' button actions
    $('.cancel').click (cancel) ->
      cancel.preventDefault()
      $('.new_question').hide()
      $('.ask_question').show()

publish_question = (response) ->
  new_question = JST["templates/new_question_template"] ({ question: response.question, author: response.author})
  $('.exists_questions>tbody:last').append(new_question)
  $('.question_' + response.question.id).css('background-color','grey').animate({ backgroundColor: 'transparent'}, 3000);


call_edit_question = ->
  $('#errors_alert').remove()
  $('.edit_question_link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('.question').hide()
    $('.edit_question_form').show().insertBefore('.exists_answers')

  $('.edit_question_form')
    .bind 'ajax:error', (e, xhr, status, error) ->
      response = $.parseJSON(xhr.responseText)
      if response.title && response.errors
        errors = JST["templates/errors"]({ title: response.title, errors: response.errors })
      else
        errors = JST["templates/authentication_error"]({ error: response.error })
      $(errors).insertBefore('.edit_question_form')

update_question = (response) ->
  $('.question_title').html(response.question.title)
  $('.question_body').html(response.question.body)
  $('.question_body').html(response.question.body)
  $('.question_votes_count').html(response.question.votes_count)

destroy_question = (response) ->
  $('.question_' + response.question.id).remove()

destroy_question_alerts = ->
  $('.exists_questions').on 'click', '.delete_question', (e) ->
    $('.exists_questions')
      .bind 'ajax:error', (e, xhr, status, error) ->
        response = $.parseJSON(xhr.responseText)
        errors = JST["templates/permission_errors"]({ alert: response.alert })
        $(errors).insertBefore('.exists_questions')

$(document).on 'turbolinks:load', () ->
  subscribeToQuestions()
  call_creating_question()
  call_edit_question()
  destroy_question_alerts()
