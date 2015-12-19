# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  $('body').find('.js-redirect-on-change').on 'change', ->
    el = $(this)
    window.location.href = el.find(':selected').data('location')
    return
  return