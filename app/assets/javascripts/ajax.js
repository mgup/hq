$(function() {
    $('.ajax-group_id').each(function() {
        var $this = $(this);
 
        var updateGroupsList = function(data) {
            $this.empty();
            $this.append($('<option></option>').attr({
                        'value': ''
                    }).html('все группы'));
            $.each(data, function() {
                $this.append(
                    $('<option></option>').attr({
                        'value': this.id,
                        'selected': ($('#subject_group').val() == this.id ? true : false)
                    }).html(this.name)
                );
            });
            
            $('select').trigger('liszt:updated');
        };
 

        $('.ajax-speciality').each(function() {     
           $(this).change(function() {
              $.getJSON(
                'ajax/groups',
                {
                    'speciality': $(this).val(),
                    'form'      : $('#form').val(),
                    'course'    : $('#course_study').val(),
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
                    'course'     : $('#course_study').val(),
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
                    'course'     : $('#course_study').val(),
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
                                    'value': ''
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
                                'course'    : $('#course_study').val(),
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

    $('#disciplines').each(function() {
        $('#formsearchdisciplinebyname').submit(function() {
            $.getJSON(
                'ajax/disciplines',
                {'discipline_name': $('#discipline_name').val()},
                function(data) {
                    var $el = $('#disciplines');
                    $el.empty();
                    $(data).each(function() {
                        $el.append($('<tr></tr>').attr({'id': 'tr'+ this.id}));
                        $row = $('#disciplines #tr'+ this.id);
                        $row.append(
                        $('<td></td>').attr('class', 'text-muted')
                         .text(this.id)
                         );
                        $row.append(
                           "<td><p>" + this.name + " (" + this.term + ")</p><p>" + this.group + ", " + this.teachers + "</p></td>"
                        );
                        $href1 = '/study/disciplines/' + this.id + '/checkpoints';
                        $row.append(
                          "<td style='width: 50px;'><a class='btn btn-default' href=" + $href1 + " title='Внести данные'><span class='glyphicon glyphicon-list-alt'></span></a></td>"
                        );
                        $href2 = '/study/disciplines/' + this.id + '/edit';
                        $row.append(
                          "<td><a class='btn btn-default' href=" + $href2 + " title='Редактировать дисциплину'><span class='glyphicon glyphicon-edit'></span></a></td>"
                        );
                    });
                    $count = $(data).size();
                    $div = $('.disciplines_count')
                    $div.empty();
                    $div.append('Всего: ' + $count);
                    $el.trigger('liszt:updated');
                    $div.trigger('liszt:updated');
                }
            );
            return false;
        });
    });

    $('#filterforsubjects').submit(function() {
        $.getJSON(
            '/study/ajax/subjects',
            {'subject_name': $('#subject_name').val(),
             'subject_group': $('#subject_group option:selected').val()},
            function(somedata) {
                $element = $('table#subjects tbody');
                $('.paginator').empty();
                $element.empty();
                $(somedata).each(function() {
                    $element.append($('<tr></tr>').attr({'id': 'tr'+ this.id}));
                    $str = $('#subjects #tr'+ this.id);
                    $str.append(
                        $('<td></td>').attr('class', 'text-muted')
                            .text(this.id)
                    );
                    $next = this.year + 1;
                    $str.append(
                        $('<td></td>').text(this.year + '/' + $next )
                    );
                    $str.append(
                        $('<td></td>').text(this.semester)
                    );
                    $str.append(
                        $('<td></td>').text(this.group)
                    );
                    $str.append(
                        $('<td></td>').text(this.title)
                    );
                    $str.append(
                        $('<td></td>').text(this.type)
                    );
                    $goto = '/study/subjects/' + this.id + '/marks';
                    $str.append(
                        "<td><a  href=" + $goto + ">Посмотреть</a></td>"
                    );
                });

                $element.trigger('liszt:updated');
            }
        );
        return false;
    });
    $('select#choose_group_id').change(function() {
        $.getJSON(
            '/my/ajax/students',
            {'group': $('#choose_group_id').val()},
            function(somedata) {
                $element = $('table#students');
                $element.empty();
                $(somedata).each(function() {
                    $element.append($('<tr></tr>').attr({'id': 'tr'+ this.id}));
                    $str = $('#students #tr'+ this.id);
                    $str.append(
                        $('<td></td>').attr('class', 'text-muted')
                            .text(this.id)
                    );
                    $str.append(
                        $('<td></td>').text(this.name)
                    );
                    $goto = '/my/student/' + this.id + '/progress';
                    $str.append(
                        "<td><a class='btn btn-info'  href=" + $goto + ">Выбрать</a></td>"
                    );
                });

                $element.trigger('liszt:updated');
            }
        );
    });

   
});