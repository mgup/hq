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

//$(function(){
//    $(function() {
//        var orderDiv = $('div#create_order');
//        var orderTable = $('div#create_order table tbody');
//        orderDiv.hide();
//
//        /**
//         * Общее количество элементов исходя из текущей страницы.
//         */
//        var currentItems = $('div#ajax_content').data('currentitems');
//
//        /**
//         * Всего элементов.
//         */
//        var totalItems = $('div#ajax_content').data('totalitems');
//
//        /**
//         * Всего страниц.
//         */
//        var pageCount = $('div#ajax_content').data('pages');
//
//        /**
//         * Адрес, куда идет обращение скрипта при паджинации.
//         */
//        var href = $('div#ajax_content').data('href');
//
//        /**
//         * Текущая страница.
//         */
//        var currentPage = $('ul.pagination li.active a').text();
//        if ('undefined' == typeof(currentPage)) {
//            currentPage = 1;
//        }
//
//        /**
//         * Функция обработки входящих данных в урле.
//         */
//        function getData() {
//            var query = location.href;
//            var queryArray = [];
//            var vars = query.split("&");
//            for (var i = 0; i < vars.length; i++) {
//                var pair = vars[i].split("=");
//                /**
//                 * Если у нас в урле есть студенты,
//                 * которых мы включаем в приказ, то
//                 * получаем их данные и включаем в
//                 * табличку с созданием приказа.
//                 */
//                if (pair[0] == 'exception[]') {
//                    $.get(
//                        '/ajax/orderstudent',
//                        {id: pair[1]},
//                        function(data) {
//                            var row = '<tr><td class="id">' + data.id + '</td>'
//                                + '<td>' + data.fname + '</td>'
//                                + '<td>' + data.iname + '</td>'
//                                + '<td>' + data.oname + '</td>'
//                                + '<td>' + data.faculty + '</td>'
//                                + '<td>' + data.group + '</td>'
//                                + '<td class="image">'
//                                + '<a class="btn btn-default orderremove" href="#">'
//                                + '<span class="glyphicon glyphicon-arrow-down"></span>'
//                                + '</a></td></tr>'
//                            orderTable.append(row);
//                            checkCount();
//                        }
//                    );
//                }
//            }
//        }
//
//        /**
//         * Если у нас есть элемент - добавление студентов в приказ,
//         * то смотрим его, считаем в нем количество студентов,
//         * если оно 0, то скрываем.
//         */
//        function checkCount() {
//            var l = orderTable.find('tr').length;
//            if (l == 0) {
//                orderDiv.hide();
//            } else {
//                orderDiv.show();
//            }
//        }
//
//        function setCreateOrder() {
//            $('a.orderadd').click(function(e) {
//                var tr = $(this).closest('tr');
//                var img = tr.find('span');
//                img.removeClass('glyphicon-arrow-up');
//                img.addClass('glyphicon-arrow-down');
//                $(this).removeClass('orderadd');
//                $(this).addClass('orderremove');
//                orderTable.append(tr);
//                processData();
//                e.preventDefault();
//                checkCount();
//            });
//            $('a').click(function() {
//                $('a.orderremove').click(function(e) {
//                    e.preventDefault();
//                    var tr = $(this).closest('tr');
//                    tr.remove();
//                    location.href = processData();
//                    checkCount();
//                });
//            });
//        }
//
//        /**
//         * Обработка данных и помещение их в адресную строку.
//         */
//        function processData(url) {
//            var data = $('#formstudentsearch').serialize();
//            /**
//             * Добавляем в дату массив исключений (если мы создаем приказ).
//             */
//            var template = '';
//            if ($('#order_template')[0]){
//                template = "template=" + $('#order_template option:selected').val();
//            }
//
//            var exceptions = "";
//            $('div#create_order table>tbody>tr>td:nth-child(1)').each( function(){
//                exceptions = exceptions + "&exception[]=" + $(this).text();
//            });
//
//            var totalData;
//            if (null == url) {
//                if (currentPage == '') {currentPage = 1};
//                totalData = href + currentPage + '/?&' + template + data + exceptions;
//                history.pushState(
//                    null,
//                    null,
//                    totalData
//                );
//            } else {
//                totalData = url;
//            }
//
//            return totalData;
//        }
//
//        /**
//         * Кнопка "Следующая".
//         */
//        function next() {
//            currentPage++;
//        }
//
//        /**
//         * Кнопка "Предыдущая".
//         */
//        function prev() {
//            if (currentPage > 1) {
//                currentPage--;
//            }
//        }
//
//        function setListeners() {
//            $('a.print').click(function() {
//                var data = $('#formstudentsearch').serialize();
//                location.href = href + 'print/?' + data + '&print=1';
//            });
//
//            $('button[type=submit],input[type=submit]').click(function(e) {
//                e.preventDefault();
//                location.href = processData();
//            });
//
//            $('ul.pagination li.page').click(function(e) {
//                e.preventDefault();
//                currentPage = $(this).find('a').text();
//                location.href = processData();
//            });
//
//            $('ul.pagination li.next').click(function(e) {
//                if (!$(this).hasClass('disabled')) {
//                    e.preventDefault();
//                    next();
//                    location.href = processData();
//                }
//            });
//
//            $('ul.pagination li.prev').click(function(e) {
//                if (!$(this).hasClass('disabled')) {
//                    e.preventDefault();
//                    prev();
//                    location.href = processData();
//                }
//            });
//
//            /**
//             * Обработка нажатия на сброс фильтров.
//             */
//            $('.form_reset').click(function(e) {
//                e.preventDefault();
//                location.href = href;
//            });
//
////            $('#process').click(function(e){
////                var href = location.href;
////                var data = href.split('?');
////                location.href = '/orders/create/?' + data[1];
////                e.preventDefault();
////            });
//
//            $('#order_template').change(function() {
//                location.href = processData();
//            });
//
//        }
//        if ($('#formstudentsearch')[0]){
//            setListeners();
//            setCreateOrder();
//            getData();
//        }
//    });
//})

//$(function(){
//    $('.save_ciot').click(function(){
//        div = $(this).closest('div');
//        $student =  div.find('input').val();
//        $('#edit_student_' + $student).trigger('submit');
//        var login = $('#edit_student_' + $student).find('#student_ciot_login');
//        var password = $('#edit_student_' + $student).find('#student_ciot_password');
//        login.attr('value', login.val());
//        password.attr('value', password.val());
//        $('.modal').modal('hide');
//        $('div#ajax_content table>tbody>tr>td:nth-child(1)').each(function(){
//            if ($(this).text() == $student ){
//                var tr = $(this).closest('tr');
//                $(tr.children().get(5)).html($('#edit_student_' + $student).find('#student_ciot_login').val());
//                $(tr.children().get(6)).html($('#edit_student_' + $student).find('#student_ciot_password').val());
//            }
//        })
//    })
//    function returnValues(elem){
//        div = elem.closest('.modal');
//        $student =  div.find('.modal-footer').find('input').val();
//        var login = $('#edit_student_' + $student).find('#student_ciot_login');
//        var password = $('#edit_student_' + $student).find('#student_ciot_password');
//        login.val(login.attr('value'));
//        password.val(password.attr('value'));
//    }
//    $('.close').click(function(){
//        returnValues($(this));
//    })
//    $('.cancell').click(function(){
//        returnValues($(this));
//    })
//
//})