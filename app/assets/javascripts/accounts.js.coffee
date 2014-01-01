# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

	form = $('#new_account')
	form.submit ->
		event.preventDefault();
		val = $('#account_current_balance').val()
		$('#account_current_balance').val(val.replace(/\D/,""))
		form.unbind().submit()