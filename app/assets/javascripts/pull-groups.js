$(function(){
      $('#formpullgroupstudents').change(function() {
        $.getJSON(
            '/ajax/group_students',
            {'faculty': $('#faculty').val(),
             'form' : $('#form option:selected').val(),
             'course' : $('#course option:selected').val(),
             'speciality' : $('#speciality option:selected').val()
            },
            function(data) {
                var $element = $('table#studentsByGroups').find('tr');
                $element.empty();
                $(data).each(function() {
                    $element.append($('<td style="vertical-align: top;"></td>').attr({'id': this.id}));
                    var $group = $('#studentsByGroups #' + this.id);
                    $group.append('<h3 class="print-students-from-group">' + this.name + '  <span class="glyphicon glyphicon-print"></span></h3>');
                    $group.append(
                        $('<ul class="list-unstyled nav nav-stacked"></ul>')
                    );
                    var $ul = $group.find('ul');
                    $(this.students).map(function(){
                        var $budget = (this.budget == 0 ? 'no-budget-students' : '');
                        $ul.append('<li class="' + $budget + '"><a href="#" style="color: black;"><strong>' + this.index + '</strong>  ' + this.fullname +'</a></li>');
                    });

                });

                $element.trigger('liszt:updated');
                $(document).find('.print-students-from-group').click(function(){
                    var $href = '/groups/'+ $(this).closest('td').attr('id') + '/print_group.pdf';
                    window.location = $href;
                })

            });
      });





})