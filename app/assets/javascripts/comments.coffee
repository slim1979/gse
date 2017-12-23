# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      console.log 'Комментарии подключились'
      @perform 'follow'
      ,
    received: (data) ->
      response = $.parseJSON(data)
      console.log response
      object_type = response.new_comment.self['commented_type'].toLowerCase()
      object_id = response.new_comment.self['commented_id']
      comment = response.new_comment.self
      user = response.new_comment.user
      datetime = response.new_comment.datetime
      object = $('.' + object_type + '_' + object_id)
      template = JST['templates/new_comment']({ comment: comment, user: user, datetime: datetime })
      - if object.find('.comments div').length > 0
        last_div = object.find('.comments div:last')
        $(template).insertAfter(last_div)
      else
        object.find('.comments').append(template)
    })
comments = ->
  $('.new_comment_link').on 'click', (e) ->
    e.preventDefault()
    object = $(this).data('class')
    $(object).find('.new_comment_link').hide()
    $(object).find('.new_comment_form').show()
    $(object).find('.new_comment_form')
      .bind 'ajax:success', (e, xhr, status, data) ->
        $(object).find('form#new_comment')[0].reset()
        $(object).find('form#new_comment').off()
        $('.new_comment_form').hide()
        $('.new_comment_link').show()

$(document).on 'turbolinks:load', () ->
  comments()
