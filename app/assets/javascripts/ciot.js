$(function(){
    $('.save_ciot').click(function(){
        div = $(this).closest('div');
        $student =  div.find('input').val();
        $('#edit_student_' + $student).trigger('submit');
        location.href = '/ciot'
    })

})