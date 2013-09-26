// Здесь собраны функции, которые нужно будет либо переписать, либо удалить

//$(function(){
      // Фильтр для поика дисциплины по названию, но он был убран, поэтому нужна ли функция?
//    $('#disciplines').each(function() {
//        $('#formsearchdisciplinebyname').submit(function() {
//            $.getJSON(
//                'ajax/disciplines',
//                {'discipline_name': $('#discipline_name').val()},
//                function(data) {
//                    var $el = $('#disciplines');
//                    $el.empty();
//                    $(data).each(function() {
//                        $el.append($('<tr></tr>').attr({'id': 'tr'+ this.id}));
//                        $row = $('#disciplines #tr'+ this.id);
//                        $row.append(
//                            $('<td></td>').attr('class', 'text-muted')
//                                .text(this.id)
//                        );
//                        $row.append(
//                            "<td><p>" + this.name + " (" + this.term + ")</p><p>" + this.group + ", " + this.teachers + "</p></td>"
//                        );
//                        $href1 = '/study/disciplines/' + this.id + '/checkpoints';
//                        $row.append(
//                            "<td style='width: 50px;'><a class='btn btn-default' href=" + $href1 + " title='Внести данные'><span class='glyphicon glyphicon-list-alt'></span></a></td>"
//                        );
//                        $href2 = '/study/disciplines/' + this.id + '/edit';
//                        $row.append(
//                            "<td><a class='btn btn-default' href=" + $href2 + " title='Редактировать дисциплину'><span class='glyphicon glyphicon-edit'></span></a></td>"
//                        );
//                    });
//                    $count = $(data).size();
//                    $div = $('.disciplines_count')
//                    $div.empty();
//                    $div.append('Всего: ' + $count);
//                    $el.trigger('liszt:updated');
//                    $div.trigger('liszt:updated');
//                }
//            );
//            return false;
//        });
//    });

      // Для редактирования оценки студента за занятия, не знаю, будет ли нужно
//    $('.mark-editor').click( function () {
//        var $this = $(this);
//        var $student =  $this.data('value');
//        $('#check_result_' + $student).css({ 'display': 'block' });
//    });


    //  Фильтры для результатаов сессии, будут ли нужны?
//    $('#filterforsubjects').submit(function() {
//        $.getJSON(
//            '/study/ajax/subjects',
//            {'subject_name': $('#subject_name').val(),
//                'subject_group': $('#subject_group option:selected').val()},
//            function(somedata) {
//                $element = $('table#subjects tbody');
//                $('.paginator').empty();
//                $element.empty();
//                $(somedata).each(function() {
//                    $element.append($('<tr></tr>').attr({'id': 'tr'+ this.id}));
//                    $str = $('#subjects #tr'+ this.id);
//                    $str.append(
//                        $('<td></td>').attr('class', 'text-muted')
//                            .text(this.id)
//                    );
//                    $next = this.year + 1;
//                    $str.append(
//                        $('<td></td>').text(this.year + '/' + $next )
//                    );
//                    $str.append(
//                        $('<td></td>').text(this.semester)
//                    );
//                    $str.append(
//                        $('<td></td>').text(this.group)
//                    );
//                    $str.append(
//                        $('<td></td>').text(this.title)
//                    );
//                    $str.append(
//                        $('<td></td>').text(this.type)
//                    );
//                    $goto = '/study/subjects/' + this.id + '/marks';
//                    $str.append(
//                        "<td><a  href=" + $goto + ">Посмотреть</a></td>"
//                    );
//                });
//
//                $element.trigger('liszt:updated');
//            }
//        );
//        return false;
//    });

    // Просьбы студентов при вводе оценок по сессиям, по идее, можно удалить
//    $('#semester_count').on('change', function() {
//        var $this = $(this);
//        if ((+$this.val() > 12) || (+$this.val() < 1) ||
//            (+$this.val() != parseInt($this.val()))){
//            $this.val('');
//        }
//        else {
//            var $semester = $this.val()%2 ? 1 : 2;
//            var $course = (+$this.val() + ($this.val()%2))/2;
//            $('#study_subject_semester').val($semester);
//            var $list = $('#pillsemester li');
//            $list.map(function(){
//                if ($(this).find('a').data('value') == $semester){
//                    $(this).addClass('active');
//                }
//                else{
//                    $(this).removeClass('active');
//                }
//            });
//            $('input#course_study').val($course);
//            var $li = $('#pillcourse li');
//            $li.map(function(){
//                if ($(this).find('a').data('value') == $course){
//                    $(this).addClass('active');
//                    $(this).find('a').trigger('shown.bs.tab');
//                }
//                else{
//                    $(this).removeClass('active');
//                }
//            });
//        }
//    });
//    $('#course_study').on('change', function() {
//      var $this = $(this);
//      var $course = (+$this.val())*2
//      var $semester = +$('#study_subject_semester').val()%2;
//      $('#semester_count').val($course-$semester);
//    });
//    $('#study_subject_semester').on('change', function() {
//      var $this = $(this);
//      var $course = (+$('#course_study').val())*2
//      var $semester = +$this.val()%2;
//      $('#semester_count').val($course-$semester);
//       if ($('input#course_study').val() == ''){
//           $('#semester_count').val(null);
//       }
//    });
//    $('#allmarks').on('change', function(){
//        $mark = $(this).val()
//        $('.all_mark').val($mark).change();
//        var $limarks = $('#pillmark li');
//        $limarks.map(function(){
//            if ($(this).find('a').data('value') == $mark){
//                $(this).addClass('active');
//                $(this).find('a').trigger('shown.bs.tab');
//            }
//            else{
//                $(this).removeClass('active');
//            }
//        });
//    });
//    $('.all_mark').map(function () {
//      $(this).attr('oldValue', $(this).val());
//    });
//    $('.all_mark').map( function () {
//      $(this).on('change', function(){
//        $elem = $('#mark' + $(this).val())
//        $counter = +$elem.val()+1
//        $elem.val($counter);
//        var oldValue = $(this).attr('oldValue');
//          if (oldValue != ''){
//            $('#mark' + oldValue).val(+$('#mark' + oldValue).val()-1);
//           }
//        $(this).attr('oldValue', $(this).val());
//      });
//    });
//    if ($('input#course_study').val() != null){
//        var $li = $('#pillcourse li');
//        $course = $('input#course_study').val();
//        $li.map(function(){
//            if ($(this).find('a').data('value') == $course){
//                $(this).addClass('active');
//                $(this).find('a').trigger('shown.bs.tab');
//            }
//            else{
//                $(this).removeClass('active');
//            }
//        });
//    }
//    if ($('input#study_subject_semester').val() != null){
//        var $li = $('#pillsemester li');
//        $semester = $('input#study_subject_semester').val();
//        $li.map(function(){
//            if ($(this).find('a').data('value') == $semester){
//                $(this).addClass('active');
//                $(this).find('a').trigger('shown.bs.tab');
//            }
//            else{
//                $(this).removeClass('active');
//            }
//        });
//        if ($('input#course_study').val() == ''){
//            $('#semester_count').val(null);
//        }
//    }
//    if ($('input#form').val() != null){
//        var $li = $('#pillform li');
//        $form = $('input#form').val();
//        $li.map(function(){
//            if ($(this).find('a').data('value') == $form){
//                $(this).addClass('active');
//                $(this).find('a').trigger('shown.bs.tab');
//            }
//            else{
//                $(this).removeClass('active');
//            }
//        });
//    }
//    if ($('input#study_subject_year').val() != null){
//        var $li = $('#pillyear li');
//        $year = $('input#study_subject_year').val();
//        $li.map(function(){
//            if ($(this).find('a').data('value') == $year){
//                $(this).addClass('active');
//                $(this).find('a').trigger('shown.bs.tab');
//            }
//            else{
//                $(this).removeClass('active');
//            }
//        });
//    }
//    if ($('input#faculty').val() != null){
//        var $li = $('#pillfaculty li');
//        $faculty = $('input#faculty').val();
//        $li.map(function(){
//            if ($(this).find('a').data('value') == $faculty){
//                $(this).addClass('active');
//                $(this).find('a').trigger('shown.bs.tab');
//            }
//            else{
//                $(this).removeClass('active');
//            }
//        });
//    }


    // По идее не нужно, так как вход в кабинет студента автоматический
//    $('select#choose_group_id').change(function() {
//        $.getJSON(
//            '/my/ajax/students',
//            {'group': $('#choose_group_id').val()},
//            function(somedata) {
//                $element = $('table#students');
//                $element.empty();
//                $(somedata).each(function() {
//                    $element.append($('<tr></tr>').attr({'id': 'tr'+ this.id}));
//                    $str = $('#students #tr'+ this.id);
//                    $str.append(
//                        $('<td></td>').attr('class', 'text-muted')
//                            .text(this.id)
//                    );
//                    $str.append(
//                        $('<td></td>').text(this.name)
//                    );
//                    $goto = '/my/student/' + this.id;
//                    $str.append(
//                        "<td><a class='btn btn-info'  href=" + $goto + ">Выбрать</a></td>"
//                    );
//                });
//
//                $element.trigger('liszt:updated');
//            }
//        );
//    });

//})