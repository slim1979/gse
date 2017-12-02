# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

stady = ->
  $('.edit_question_link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.question').hide();
    $('.edit_question_form').show();

$(document).on('turbolinks:load', stady)
