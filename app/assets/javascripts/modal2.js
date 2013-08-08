$(function() {
    $('a[data-toggle="modal"]').on('click', function() {
        var $this = $(this);
        var my_target = $this.data('target');
        var my_path = $this.data('path');
        $(my_target + ' #modal_form').attr('action', my_path);
        if($this.data('value') != null){
           $(my_target + ' #modal_form').attr('method', 'patch');
           $('#myModal h4').empty().append('Редактировать занятие');
           $('#modalEdit').val('Редактировать');
           $.getJSON(
                '/ajax/checkpoint',
                {'checkpoint_id': $this.data('value')},
                function(control) {
                    $('#study_checkpoint_type').val(control.type);
                    var $li = $('#pillcheckpoint_type li');
                    $li.map(function(){
                        if ($(this).find('a').data('value') == control.type){
                            $(this).addClass('active');
                            $(this).find('a').trigger('shown.bs.tab');
                        }
                        else{
                            $(this).removeClass('active');
                        }
                    });
                    $('.datepicker').val(control.date).trigger('changeDate');
//                    $('.datepicker').datepicker('setValue', control.date)
                    $('#study_checkpoint_name').val(control.name);
                    $('#study_checkpoint_details').val(control.details);
                });
        }
        $(my_target + ' #modal_form #study_checkpoint_id').val( $this.data('value'));

    });
})
