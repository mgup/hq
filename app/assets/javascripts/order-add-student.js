$(function(){
    $(function() {
        var orderDiv = $('div#create_order');
        var orderTable = $('div#create_order table tbody');
        var ajaxTable = $('div#ajax_content table tbody');
        var spinner = '<div id="spinner">' +
            '<img id="loading" src="/img/spinner128.gif">' +
            '</div>';
        var loading = false;
        $(spinner).hide();
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
                                + '<a class="orderremove btn btn-default" href="#">'
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
                $(this).attr('class', 'orderremove btn btn-default');
                orderTable.append(tr);
                processData();
                e.preventDefault();
                checkCount();
            });
            $('a.orderremove').click(function(e) {
                var tr = $(this).closest('tr');
                tr.remove();
                renderContent();
                e.preventDefault();
                checkCount();
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
            var exceptions = "";
            $('div#create_order table>tbody>tr>td:nth-child(1)').each( function(){
                exceptions = exceptions + "&exception[]=" + $(this).text();
            });

            var totalData;
            if (null == url) {
                totalData = href + currentPage + '/?&' + data + exceptions;
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
         * Загрузка нужного контента.
         */
        function renderContent(url) {
            var data = processData(url);
            switchSpinner();
            $('#ajax_content').html('');
            $(spinner).appendTo('#ajax_content');
            updateContent(data, url);
        }

        /**
         * Функция обновляющая див с контентом.
         */
        function updateContent(data, url) {
            var hr;
            if (null == url) {
                hr = href + currentPage;
            } else {
                hr = url;
            }
            $.get(
                hr,
                data,
                function(data) {
                    $('#ajax_content').replaceWith(data);
                    switchSpinner();
                }
            );
        }

        /**
         * Кнопка "Следующая".
         */
        function next() {
            currentPage++;
            renderContent();
        }

        /**
         * Кнопка "Предыдущая".
         */
        function prev() {
            if (currentPage > 1) {
                currentPage--;
            }
            renderContent();
        }

        /**
         * Включение/выключение спиннера.
         */
        function switchSpinner() {
            if (!loading) {
                $(spinner).show();
                loading = true;
            } else {
                $(spinner).hide();
                loading = false;
            }
        }

        function setListeners() {
            $('a.print').click(function(e) {
                var data = $('#formstudentsearch').serialize();
                location.href = href + 'print/?' + data + '&print=1';
                e.preventDefault();
            });

            $('button[type=submit],input[type=submit]').click(function(e) {
                    renderContent();
                    e.preventDefault();
                });

            $('ul.pagination li.page').click(function(e) {
                currentPage = $(this).closest('a').text();
                renderContent();
                $('html, body').animate({scrollTop: '0px'}, 300);
                e.preventDefault();
            });

            $('ul.pagination li.next').click(function(e) {
                if (!$(this).hasClass('disabled')) {
                    next();
                }
                $('html, body').animate({scrollTop: '0px'}, 300);
                e.preventDefault();
            });

            $('ul.pagination li.prev').click(function(e) {
                if (!$(this).hasClass('disabled')) {
                    prev();
                }
                $('html, body').animate({scrollTop: '0px'}, 300);
                e.preventDefault();
            });

            /**
             * Обработка нажатия на сброс фильтров.
             */
            $('.form_reset').click(function(e) {
                e.preventDefault();
                location.href = href;
            });

        }

        setListeners();
        setCreateOrder();
        getData();
    });
})