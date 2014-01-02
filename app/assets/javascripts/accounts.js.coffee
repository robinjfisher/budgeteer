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
	
	$('#category-list').hide()
	$('.input-holder').on 'focus','.category_name', ->
		$('#category-list').show()
		$('#category-list').appendTo($(this).parents("td")).css({
			'overflow':'visible',
			'position':'absolute'
		})
		$('ol').on 'click','.category', ->
			input = $(this).parents("#category-list").siblings("input")
			input.val($(this).text())
			transactionId = input.attr("id").replace(/category_name_/,"")
			$('#category-list').hide()
			$.ajax({
				type:'POST',
				url:'/categories/update_transaction',
				data:{category: input.val(), transaction_id: transactionId}
			}).done (data) ->
				td = input.parents("td")
				input.hide()
				td.text(data['category']['name'])
		$(document).keyup (event) ->
			if event.keyCode is 27
				$('#category-list').hide()
		$('.category_name').keyup (event) ->
			if event.keyCode is 13
				$('#category-list').hide()
				input = $(this)
				transactionId = input.attr("id").replace(/category_name_/,"")
				$('#category-list').hide()
				$.ajax({
					type:'POST',
					url:'/categories/create',
					data:{category: input.val(), transaction_id: transactionId}
				}).done (data) ->
					td = input.parents("td")
					input.hide()
					td.text(data['category']['name'])
	
	$('.sub.category').hover \
		(-> $(this).css({
			'cursor':'pointer',
			'background-color':'rgb(51,51,51)',
			'color':'rgb(221,221,221)'
		})),
		(-> $(this).css({
			'cursor':'default',
			'background-color':'rgba(221,221,221,0.75)',
			'color':'rgb(51,51,51)'
		}))