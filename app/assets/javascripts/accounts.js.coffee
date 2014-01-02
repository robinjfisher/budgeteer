# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

	form = $('#new_account')
	form.submit ->
		event.preventDefault();
		val = $('#account_current_balance').val()
		$('#account_current_balance').val(val.replace(/\./,""))
		form.unbind().submit()
	
	$('#category-list').hide()
	
	$('table tbody tr').on 'focus','.category_name', ->
		$('#category-list').show()
		$('#category-list li').each ->
			$(this).show()
		$('#category-list').appendTo($(this).parents("td")).css({
			'overflow':'visible',
			'position':'absolute'
		})
	
	$('ol').on 'click','.category', ->
		input = $(this).parents("#category-list").siblings("input")
		transactionId = input.attr("id").replace(/category_name_/,"")
		input.val($(this).text())
		$('#category-list').appendTo($("body"))
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
			
	$('table tbody tr').on 'keyup','.category_name', (event) ->
		if event.keyCode is 13
			$('#category-list').appendTo($("body"))
			$('#category-list').hide()
			input = $(this)
			transactionId = input.attr("id").replace(/category_name_/,"")
			$.ajax({
				type:'POST',
				url:'/categories/create',
				data:{category: input.val(), transaction_id: transactionId}
			}).done (data) ->
				td = input.parents("td")
				input.hide()
				td.text(data['category']['name'])
		else
			categories = $('#category-list li.sub.category')
			val = $(this).val()
			unless val.length is 0
				regex = new RegExp($(this).val())
				categories.each ->
					if regex.test($(this).text())
						$(this).show()
					else
						$(this).hide()
	
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
	
	$('table tbody tr').on 'click','.payee', ->
		$(this).replaceWith('<input class="payee-input form-control"></input>')
	
	$('table tbody tr').on 'keyup','.payee-input', (event) ->
		if event.keyCode is 13
			input = $(this)
			transactionId = input.parents("tr").attr("id").replace(/transaction-/,"")
			$.ajax({
				type:'PATCH',
				url:'/transactions/' + transactionId,
				data: {transaction: {payee:$(this).val()}}
			}).done (data) ->
				input.replaceWith(data['payee'])
	
	$('table tbody tr').on 'click','.category-name-holder', ->
		transactionId = $(this).parents("tr").attr("id").replace(/transaction-/,"")
		$(this).replaceWith('<td class="input-holder"><input class="form-control category_name" id="category_name_' + transactionId + '"></input></td>')

	$('.confirm-transaction').on 'change', ->
		transactionId = $(this).parents("tr").attr("id").replace(/transaction-/,"")
		if this.checked
			$.ajax({
				type:'PATCH',
				url:'/transactions/' + transactionId
				data: {transaction: {payee_confirmed:this.checked}}
			}).done (data) ->
				if data['payee_confirmed'] is "true"
					$(this).attr('checked','checked')
	
	$('.one-off-transaction').on 'change', ->
		transactionId = $(this).parents("tr").attr("id").replace(/transaction-/,"")
		if this.checked
			$.ajax({
				type:'PATCH',
				url:'/transactions/' + transactionId
				data: {transaction: {one_off:this.checked}}
			}).done (data) ->
				if data['one_off'] is "true"
					$(this).attr('checked','checked')