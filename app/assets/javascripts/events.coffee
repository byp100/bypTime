# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


jQuery ($) ->
  event_id = $('.check_in').data('event-id')
  $('.check_in').bind 'change', ->
    $.ajax
      url: '/members/' + @value + '/check_in'
      type: 'POST'
      data: 'check_in': @checked, 'event_id': event_id