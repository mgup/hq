$(function(){
    $(function() {
        var orderDiv = $('div#create_order');
        var orderTable = $('div#create_order table tbody');
        orderDiv.hide();

        /**
         * Общее количество элементов исходя из текущей страницы.
         */
        var currentItems = $('div#ajax_content').data('currentitems');

        /**
         * Всего элементов.
         */
        var totalItems = $('div#ajax_content').data('totalitems');

        /**
         * Всего страниц.
         */
        var pageCount = $('div#ajax_content').data('pages');

        /**
         * Адрес, куда идет обращение скрипта при паджинации.
         */
        var href = $('div#ajax_content').data('href');

        /**
         * Текущая страница.
         */
        var currentPage = $('ul.pagination li.active a').text();
        if ('undefined' == typeof(currentPage)) {
            currentPage = 1;
        }

        /**
         * Функция обработки входящих данных в урле.
         */
        function getData() {
            var query = location.href;
            var queryArray = [];
            var vars = query.split("&");
            for (var i = 0; i < vars.length; i++) {
                var pair = vars[i].split("=");
                /**
                 * Если у нас в урле есть студенты,
                 * которых мы включаем в приказ, то
                 * получаем их данные и включаем в
                 * табличку с созданием приказа.
                 */
                if (pair[0] == 'exception[]') {
                    $.get(
                        '/ajax/orderstudent',
                        {id: pair[1]},
                        function(data) {
                            var row = '<tr><td class="id">' + data.id + '</td>'
                                + '<td>' + data.fname + '</td>'
                                + '<td>' + data.iname + '</td>'
                                + '<td>' + data.oname + '</td>'
                                + '<td>' + data.faculty + '</td>'
                                + '<td>' + data.group + '</td>'
                                + '<td class="image">'
                                + '<a class="btn btn-default orderremove" href="#">'
                                + '<span class="glyphicon glyphicon-arrow-down"></span>'
                                + '</a></td></tr>'
                            orderTable.append(row);
                            checkCount();
                        }
                    );
                }
            }
        }

        /**
         * Если у нас есть элемент - добавление студентов в приказ,
         * то смотрим его, считаем в нем количество студентов,
         * если оно 0, то скрываем.
         */
        function checkCount() {
            var l = orderTable.find('tr').length;
            if (l == 0) {
                orderDiv.hide();
            } else {
                orderDiv.show();
            }
        }

        function setCreateOrder() {
            $('a.orderadd').click(function(e) {
                var tr = $(this).closest('tr');
                var img = tr.find('span');
                img.removeClass('glyphicon-arrow-up');
                img.addClass('glyphicon-arrow-down');
                $(this).removeClass('orderadd');
                $(this).addClass('orderremove');
                orderTable.append(tr);
                processData();
                e.preventDefault();
                checkCount();
            });
            $('a').click(function() {
                $('a.orderremove').click(function(e) {
                    e.preventDefault();
                    var tr = $(this).closest('tr');
                    tr.remove();
                    location.href = processData();
                    checkCount();
                });
            });
        }

        /**
         * Обработка данных и помещение их в адресную строку.
         */
        function processData(url) {
            var data = $('#formstudentsearch').serialize();
            /**
             * Добавляем в дату массив исключений (если мы создаем приказ).
             */
            var template = '';
            if ($('#order_template')[0]){
                template = "template=" + $('#order_template option:selected').val();
            }

            var exceptions = "";
            $('div#create_order table>tbody>tr>td:nth-child(1)').each( function(){
                exceptions = exceptions + "&exception[]=" + $(this).text();
            });

            var totalData;
            if (null == url) {
                totalData = href + currentPage + '/?&' + template + data + exceptions;
                history.pushState(
                    null,
                    null,
                    totalData
                );
            } else {
                totalData = url;
            }

            return totalData;
        }

        /**
         * Кнопка "Следующая".
         */
        function next() {
            currentPage++;
        }

        /**
         * Кнопка "Предыдущая".
         */
        function prev() {
            if (currentPage > 1) {
                currentPage--;
            }
        }

        function setListeners() {
            $('a.print').click(function() {
                var data = $('#formstudentsearch').serialize();
                location.href = href + 'print/?' + data + '&print=1';
            });

            $('button[type=submit],input[type=submit]').click(function(e) {
                e.preventDefault();
                location.href = processData();
            });

            $('ul.pagination li.page').click(function(e) {
                e.preventDefault();
                currentPage = $(this).find('a').text();
                location.href = processData();
            });

            $('ul.pagination li.next').click(function(e) {
                if (!$(this).hasClass('disabled')) {
                    e.preventDefault();
                    next();
                    location.href = processData();
                }
            });

            $('ul.pagination li.prev').click(function(e) {
                if (!$(this).hasClass('disabled')) {
                    e.preventDefault();
                    prev();
                    location.href = processData();
                }
            });

            /**
             * Обработка нажатия на сброс фильтров.
             */
            $('.form_reset').click(function(e) {
                e.preventDefault();
                location.href = href;
            });

//            $('#process').click(function(e){
//                var href = location.href;
//                var data = href.split('?');
//                location.href = '/orders/create/?' + data[1];
//                e.preventDefault();
//            });

            $('#order_template').change(function() {
                alert('xcn');
                location.href = processData();
            });

        }
        if ($('#formstudentsearch')[0]){
            setListeners();
            setCreateOrder();
            getData();
        }
    });
})