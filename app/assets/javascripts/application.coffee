#= require jquery
#= require jquery_ujs

$ ->
  $('[data-role=requests]').on 'click', '[data-role=requestTrigger]', (e) ->
    el = $(e.currentTarget)
    el.siblings().removeClass('success').end().addClass('success')
    $('[data-role=requestDetails]').addClass('blur')
    history.pushState(null, document.title, el.data('href'));
    $.get el.data('href')

  $(document).on 'click', '[data-role=showRawData]', (e) ->
    e.preventDefault();
    $('[data-role=rawData]').slideToggle()
