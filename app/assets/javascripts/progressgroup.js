$(function(){
    $('#formmychoiceselectgroup').submit(function() {
        $id = $('#progress_group_id').val();
        $url = '/study/group/' + $id + '/progress';
        $(location).attr('href', $url);
       return false;
    });

    $(document).ready(function(){
        $group = $('#progress_group').val();
        $discipline = $('#disciplines_for_group').children(":selected").val();
        $.ajax({
            url: "/study/group/" + $group + "/progress/change_discipline"
        })
     });
    $('#disciplines_for_group').change(function(){
        $discipline = $(this).children(":selected").val();
        $group = $('#progress_group').val();
        var params = ($discipline != '' ? 'discipline=' + $discipline : '');
        $.ajax({
            url: "/study/group/" + $group + "/progress/change_discipline",
            data: params
        });
    });
})
