# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $(".body_of_" + answer_id).hide();
    $(".updated_for_" + answer_id).hide();
    $('.edit_form_' + answer_id).show();
  $('.best').insertBefore('tr:first');
  $('.now-best').hide();
  $('.bold').css('font-weight','bold');
  $('.img').hide();
  $('.thumbs-up').show();

$(document).ready(ready)
$(document).on('page:update', ready)
$(document).on('turbolinks:load', ready)
