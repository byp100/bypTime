# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  $('#member_phone').mask '(999) 999-9999'

  $('#member_phone').blur ->
      #Clear the hidden field
    $('#hidden_phone').val ''
    #Create char array from phone number field
    charArray = $(this).val().split('')
    phoneNumber = ''
    #Iterate over each character in the char array
    #and determine if it is a number
    $.each charArray, (index, value) ->
      if !isNaN(value) and value != ' '
        phoneNumber = phoneNumber + value
      return
    #Set hidden field
    $('#hidden_phone').val phoneNumber
    $('#member_phone').val phoneNumber
  return