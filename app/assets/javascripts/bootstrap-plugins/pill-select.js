$(function() {
    $('.pill-select a[data-toggle="pill"]').on('shown.bs.tab', function() {
        var $this = $(this);
        $('#' + $this.data('input')).val($this.data('value')).change();
    });

    $('.hidden-pill-values').each(function(){
        $('.pill-select a[data-value="' + $(this).val() + '"][data-input="' + $(this).attr('id') + '"]').closest('li').addClass('active');
		$(this).change();
    })
    
    $('.hidden-pill-values-no-change').each(function(){
        $('.pill-select a[data-value="' + $(this).val() + '"][data-input="' + $(this).attr('id') + '"]').closest('li').addClass('active');
    })
});
