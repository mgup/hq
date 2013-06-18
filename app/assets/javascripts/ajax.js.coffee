$ ->
  $('.ajax-speciality').each ->
    $(this).change ->
      $.getJSON 'ajax/groups', { speciality: $(this).val() }, (inf) ->
        $elem = $('#group')
        $elem.empty()
        
        $elem.append $('<option></option>').attr('value', null).text('все группы')
        $(inf).each ->
          $elem.append $('<option></option>').attr('value', this.id).text("#{this.name}")

        $elem.trigger 'liszt:updated'

  $('.ajax-course').each ->
    $(this).change ->
      $.getJSON 'ajax/groups', { course: $(this).val() }, (inf) ->
        $element = $('#group')
        $element.empty()
        
        $element.append $('<option></option>').attr('value', null).text('все группы')
        $(inf).each ->
          $element.append $('<option></option>').attr('value', this.id).text("#{this.name}")

        $element.trigger 'liszt:updated'


  $('.ajax-faculty').each ->
    $(this).change ->
      $.getJSON 'ajax/specialities', { faculty: $(this).val() }, (data) ->
        $el = $('#speciality')
        $el.empty()
        
        $el.append $('<option></option>').attr('value', null).text('все специальности')
        $(data).each ->
          $el.append $('<option></option>').attr('value', this.id).text("#{this.code} #{this.name}")

        $el.trigger 'liszt:updated'

  