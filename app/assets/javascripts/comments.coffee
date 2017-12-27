# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  App.comments_subscribe = App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      subscribeToComments()

    received: (data) ->
      response = $.parseJSON(data)
      if response.new_comment
        create_comment(response.new_comment)
    })

subscribeToComments = ->
  question_id = $('.question').data('id')

  if question_id
     App.comments_subscribe.perform 'follow', id: question_id
  else
     App.comments_subscribe.perform 'unfollow'

call_to_create_comment = ->
  $('.new_comment_link').on 'click', (e) ->
    e.preventDefault()
    object = $(this).data('class')
    $(object).find('.new_comment_link').hide()
    $(object).find('.new_comment_form').show()

create_comment = (response) ->
  object_type = response.comment['commented_type'].toLowerCase()
  object_id = response.comment['commented_id']
  comment = response.comment
  user = response.user
  datetime = response.datetime
  object = $('.' + object_type + '_' + object_id)
  template = JST['templates/new_comment']({ comment: comment, user: user, datetime: datetime })
  if object.find('.comments div').length > 0
    last_div = object.find('.comments div:last')
    $(template).insertAfter(last_div)
  else
    object.find('.comments').append(template)
  $(object).find('form#new_comment')[0].reset()
  $(object).find('form#new_comment').off()
  $('.new_comment_form').hide()
  $('.new_comment_link').show()

$(document).on 'turbolinks:load', () ->
  subscribeToComments()
  call_to_create_comment()
