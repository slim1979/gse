# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  #edit form show by click on edit answer
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $(".body_of_" + answer_id).hide();
    $(".updated_for_" + answer_id).hide();
    $('.edit_form_' + answer_id).show();

  #best answer toggle
  $('.best').insertBefore('tr:first');
  $('.now-best').hide();
  $('tr.best').find('.answer_body').css('font-weight','bold');
  $('.img').hide();
  $('.thumbs-up').show();

  #clean up form text after creating answer
  $('.new_answer_body').val('');

  $('form#new_answer')
    .bind 'ajax:success', (e, data, status, xhr) ->
      answer = $.parseJSON(xhr.responseText)
      $('.answers-table > tbody:last').append('
      <tr class="row answer usual" id="answer_'+answer.id+'">
        <td class="col-sm-2">
          <a class="best-answer-link " id="best-answer-link-'+answer.id+'" data-remote="true" rel="nofollow" data-method="patch" href="/answers/'+answer.id+'/best_answer_assign">Best answer</a>
            <img alt="Best answer" class="img img-'+answer.id+' " src="/assets/best.png" width="50" height="50" style="display: none;">
        </td>
        <td>
          <div class="answer_body body_of_'+answer.id+' ">'+answer.body+'</div>
          <div class="updated_at updated_for_'+answer.id+'">'+answer.updated_at+'</div>
          <ul></ul>
          <div class="answer_error_'+answer.id+'"></div>
          <div class="edit_form edit_form_'+answer.id+'">
            <form class="edit_answer" id="edit_answer_'+answer.id+'" action="/answers/'+answer.id+'" accept-charset="UTF-8" data-remote="true" method="post">
              <input name="utf8" type="hidden" value="✓">
              <input type="hidden" name="_method" value="patch">
              <label for="answer_body">Answer</label>
              <textarea name="answer[body]" id="answer_body">'+answer.body+'</textarea>
              <input type="submit" name="commit" value="Save" data-disable-with="Save">
            </form>
          </div>
        </td>
        <td class="manage edit">
          <a class="edit-answer-link edit_answer_'+answer.id+'" data-answer-id="'+answer.id+'" href="">Edit answer</a>
        </td>
        <td class="manage delete">
          <a data-confirm="Are you sure?" data-remote="true" rel="nofollow" data-method="delete" href="/answers/'+answer.id+'">Delete answer</a>
        </td>
      </tr>')
    .bind 'ajax:error', (e, xhr, status, error) ->
      errors = $.parseJSON(xhr.responseText)
      $.each errors, (index, value) ->
        $('.answer_errors').append(value)

$(document).on('page:update', ready)
$(document).on('turbolinks:load', ready)
