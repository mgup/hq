$ ->
  $address = $('.address')

  $address.each ->
    $(this).kladr({
      oneString: true,
      withParent: true,
      change: (obj, form) -> log(obj, $('#address_'+$(this).data('value')).find('form'))
    })

  log = (obj, form) ->
    alert $(form).attr('id')
    $('.js-log li').hide()
    for parent in obj.parents
      form.find('input[name="entrance_entrant[registration_'+parent.contentType+'_name]"]').val("#{parent.name} #{parent.typeShort}")
      form.find('input[name="entrance_entrant[registration_'+parent.contentType+'_code]"]').val(parent.okato)

    form.find('input[name="entrance_entrant[registration_country_name]"]').val('Российская Федерация')
    form.find('input[name="entrance_entrant[registration_'+obj.contentType+'_name]"]').val("#{obj.name} #{obj.typeShort}")
    form.find('input[name="entrance_entrant[registration_'+obj.contentType+'_code]"]').val(obj.okato)
    form.find('input[name="entrance_entrant[azip]"]').val(obj.zip)

