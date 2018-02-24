# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', () ->
  $('body')
    .bind 'ajax:error', (e, xhr, status, error) ->
      if xhr.status == 403
        $('.alert').remove()
        if xhr.responseText
          @alert_text = JSON.parse(xhr.responseText)
        else
          @alert_text = 'Недостаточно прав'
        error = JST["templates/permission_errors"]({ alert: @alert_text })
        $(error).insertAfter('.errors_explanation')
