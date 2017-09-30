# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $(".body_of_" + answer_id).toggle();
    $(".updated_for_" + answer_id).toggle();
    $('.edit_form_' + answer_id).toggle();
