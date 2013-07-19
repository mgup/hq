$(function() {
    $('a[data-toggle="modal"]').on('click', function() {
        var $this = $(this);
        var my_target = $this.data('target');
        var my_path = $this.data('path');
//        var my_method = $this.data('method');
        $(my_target + ' #modal_form').attr('action', my_path);

        $(my_target + ' #modal_form #study_checkpoint_id').val( $this.data('value'));

    });
})
