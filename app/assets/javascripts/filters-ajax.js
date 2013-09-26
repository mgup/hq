$(function() {

    $('#filterforusers').submit(function() {
        $name = $('#name').val();
        $department = $('.chzn-select').val();
        $position = $('#position').val();
        var params = 'name=' + $name +'&department=' +
            $department + '&position=' + $position;
        $.ajax({
            url: '/users_filter',
            data: params
        });
        return false;
    });

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
   
});
