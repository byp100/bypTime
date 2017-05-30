# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

populateEmail = () ->
  email = document.cookie.split(';').map((x) ->
    x.trim().split '='
  ).reduce(((a, b) ->
    a[b[0]] = b[1]
    a
  ), {})['email']

  $('#member_email').val email.replace('%40', '@')
  return


subscribeErrorHandler = (jqXHR, textStatus, errorThrown) ->
  try
    resp = JSON.parse(jqXHR.responseText)
    console.log resp
  catch err
    console.log "Error while processing your request: #{err}"
  return

subscribeResponseHandler = (responseJSON) ->
  console.log "success!"
  window.location.reload()
  return

handleStripeToken = (token, args) ->
  $('input[name=\'stripeToken\']').val token.id
  $.ajax
    url: '/subscriptions.json'
    type: 'post'
    dataType: 'json'
    data: $('#subscribe-form').serializeArray()
    error: subscribeErrorHandler
    success: subscribeResponseHandler

$(document).ready ->
  handler = StripeCheckout.configure(
    key: 'pk_test_ZCYcc9IRBdjalYABgew5bkEZ'
    allowRememberMe: true
    token: handleStripeToken)

  populateEmail()

  $('#submit-btn').on 'click', (e) ->
    handler.open
      name: 'BYP100'
      description: $('#plan_desc').val()
      amount: $('#plan_price').val()
      email: $('#member_email').val()
    false