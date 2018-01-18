# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  App.attaches_subscribe = App.cable.subscriptions.create 'AttachesChannel',
    connected: ->
      subscribe_to_stream()

    received: (info) ->
      controller(info)

subscribe_to_stream = ->
  current_page = document.location.pathname
  question_id = $('.question').data('id')

  if current_page = '/questions/' + question_id
    App.attaches_subscribe.perform 'follow', id: question_id
  else if current_page = '/'
    App.attaches_subscribe.perform 'unfollow'

controller = (info) ->
  response = $.parseJSON(info)
  console.log response
  destroy_attach(response.destroy) if response.destroy

destroy_attach = (attach) ->
  $('#file_' + attach.id).remove()
