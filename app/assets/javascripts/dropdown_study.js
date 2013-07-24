$(function(){
    $('li#study').addClass('dropdown');
    $('li#study a').addClass('dropdown-toggle').attr('data-toggle','dropdown')
                   .attr('href','#').append("<span class='caret'></span>");
    $('li#study').append(
        "<ul class='dropdown-menu' role='menu' aria-labelledby='dLabel'>" +
            "<li><a href='/study/disciplines'>Дисциплины</a></li>" +
            "<li><a href='/study/group'>Текущая успеваемость</a></li>" +
            "<li><a href='/study/subjects'>Результаты сессий</a></li>" +
        "</ul>"
    );
    $('li#my a').addClass('dropdown-toggle').attr('data-toggle','dropdown')
        .append("<span class='caret'></span>");
    $('li#my').append(
        "<ul class='dropdown-menu' role='menu' aria-labelledby='dLabel'>" +
            "<li><a href='/my/student'>Личный кабинет</a></li>" +
            "<li><a href='/my/student/progress'>Текущая успеваемость</a></li>" +
            "</ul>"
    );
    $('.dropdown-toggle').dropdown();
})