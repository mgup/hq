$(function(){
    $('.save_ciot').click(function(){
        div = $(this).closest('div');
        $student =  div.find('input').val();
        $('#edit_student_' + $student).trigger('submit');
        var login = $('#edit_student_' + $student).find('#student_ciot_login');
        var password = $('#edit_student_' + $student).find('#student_ciot_password');
        login.attr('value', login.val());
        password.attr('value', password.val());
        $('.modal').modal('hide');
        $('div#ajax_content table>tbody>tr>td:nth-child(1)').each(function(){
            if ($(this).text() == $student ){
                var tr = $(this).closest('tr');
                $(tr.children().get(5)).html($('#edit_student_' + $student).find('#student_ciot_login').val());
                $(tr.children().get(6)).html($('#edit_student_' + $student).find('#student_ciot_password').val());
            }
        })
    })
    function returnValues(elem){
        div = elem.closest('.modal');
        $student =  div.find('.modal-footer').find('input').val();
        var login = $('#edit_student_' + $student).find('#student_ciot_login');
        var password = $('#edit_student_' + $student).find('#student_ciot_password');
        login.val(login.attr('value'));
        password.val(password.attr('value'));
    }
    $('.close').click(function(){
        returnValues($(this));
    })
    $('.cancell').click(function(){
        returnValues($(this));
    })

})