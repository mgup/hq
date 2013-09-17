$(function(){
    $('#filterforprices').submit(function() {
        $speciality = $('#speciality_name').val();
        $year = $('#year').val();
        $form = $('#form').val();
        $faculty = $('#faculty').val();
        var params = 'speciality_name=' + $speciality +'&year=' +
                     $year + '&form=' + $form + '&faculty=' + $faculty;
        $.ajax({
            url: '/finance/prices_filter',
            data: params
        });
        return false;
    });
})