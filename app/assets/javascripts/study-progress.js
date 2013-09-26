$(function(){
    $('.view-group-progress').click(function(event) {
        event.preventDefault();

        var group = $('#progress_group_id').val();
        if ('' == group || null == group) {
            alert('Сначала необходимо выбрать группу.');
        } else {
            document.location = document.location + '/' + group + '/progress';
        }
    });

    if ( $('#progress_group').val() != null) {
        $group_now = $('#progress_group').val();
        $.ajax({
            url: "/study/group/" + $group_now  + "/progress/change_discipline"
        });
    }


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
