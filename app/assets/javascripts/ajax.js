$(function() {
    $('.ajax-group_id').each(function() {
        var $this = $(this);
 
        var updateGroupsList = function(data) {
            $this.empty();
            $this.append(
                   $('<option></option>').attr({
                        'value': null
                    }).html('все группы')
                );
            $.each(data, function() {
                $this.append(
                    $('<option></option>').attr({
                        'value': this.id
                    }).html(this.name)
                );
            });
            
            $("select").trigger("liszt:updated");
        };
 

        $('.ajax-speciality').each(function() {     
           $(this).change(function() {
              $.getJSON(
                'ajax/groups',
                {
                    'speciality': $(this).val(),
                    'form'      : $('#form').val(),
                    'course'    : $('#course').val(),
                    'faculty'     : $('#faculty').val()
                },
                updateGroupsList
                );
            });
        });


        $('.ajax-course a').on('shown.bs.tab', function() {
            $.getJSON(
                'ajax/groups',
                {
                    'speciality': $('#speciality').val(),
                    'form'      : $('#form').val(),
                    'course'    : $(this).attr('data-value'),
                    'faculty'   : $('#faculty').val()
                },
                updateGroupsList
            );
        });
 
        
        $('.ajax-form a').on('shown.bs.tab', function() {
            $.getJSON(
                'ajax/groups',
                {
                    'speciality': $('#speciality').val(),
                    'form'       : $(this).attr('data-value'),
                    'course'     : $('#course').val(),
                    'faculty'     : $('#faculty').val()
                },
                updateGroupsList
            );
        });

        $('.ajax-faculty a').on('shown.bs.tab', function() {
            $.getJSON(
                'ajax/groups',
                {
                    'speciality' : $('#speciality').val(),
                    'form'       : $('#form').val(),
                    'course'     : $('#course').attr('data-value'),
                    'faculty'    : $(this).attr('data-value')
                },
                updateGroupsList
            );
        });
        
        
        $('.ajax-speciality').each(function() {
          var $this = $(this);
          
           
            var updateSpecialities = function(e) {
                $.getJSON(
                    'ajax/specialities',
                    {
                        'faculty': 'SELECT' == e.target.tagName ? $(e.target).val() : $(e.target).data('value')
                    },
                    function(data) {
                        $this.empty();
                        $this.append(
                                $('<option></option>').attr({
                                    'value': 0
                                }).html('все специальности')
                            );
                        $.each(data, function() {
                            $this.append(
                                $('<option></option>').attr({
                                    'value': this.id
                                }).html(this.code + ' ' + this.name)
                            );
                        });
                       
                        $.getJSON(
                            'ajax/groups',
                            {
                                'speciality': $('#speciality').val(),
                                'form'      : $('#form').val(),
                                'course'    : $('#course').val(),
                                'faculty'   : $('#faculty').val()
                            },
                            updateGroupsList
                        );
                    }
                );
            };
            $('.ajax-faculty a').on('shown.bs.tab', function(e) {
                updateSpecialities(e);
            });
            $('.ajax-faculty').on('change', function(e) {
                updateSpecialities(e);
            });
        });
    });
   
});