# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

subscribeErrorHandler = (jqXHR, textStatus, errorThrown) ->
  try
    resp = JSON.parse(jqXHR.responseText)
    console.log resp
  catch err
    console.log "Error while processing your request: #{err}"
  return

subscribeResponseHandler = (responseJSON) ->
  console.log "success!"
  window.location.replace "/subscriptions/#{responseJSON.id}"
  return

plan = {}

handleStripeToken = (token, args) ->
  $('input[name=\'stripeToken\']').val token.id
  $.ajax
    url: '/subscriptions.json'
    type: 'post'
    dataType: 'json'
    data: $(".subscribe-form.#{plan.id}").serializeArray()
    error: subscribeErrorHandler
    success: subscribeResponseHandler

$(document).ready ->
  handler = StripeCheckout.configure(
    key: 'pk_live_yHZtoMbhF4ZDkoZTOElAFwyx'
    allowRememberMe: true
    token: handleStripeToken)

  $('form.subscribe-form').on 'submit', (e) ->
    plan['id'] = this.children.plan_id.value
    handler.open
      name: 'BYP100'
      description: this.children.plan_desc.value
      amount: this.children.plan_price.value
      email: this.children.member_email.value
    false