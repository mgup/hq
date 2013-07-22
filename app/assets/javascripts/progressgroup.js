$(function(){
    $('#formmychoiceselectgroup').submit(function() {
        $id = $('#progress_group_id').val();
        $url = '/study/group/' + $id + '/progress';
        $(location).attr('href', $url);
       return false;
    });
    $('#disciplines_for_group').change(function() {
        $group = $('#progress_group').val();
        $discipline = $('#disciplines_for_group option:selected').val();
        $(location).attr('href', ($discipline != '' ?  $discipline : '/study/group/' + $group + '/progress'));
    });
})
