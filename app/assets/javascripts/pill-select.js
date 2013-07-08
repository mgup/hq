$(function() {
    $('.pill-select a[data-toggle="pill"]').on('shown.bs.tab', function() {
        var $this = $(this);
        $('#' + $this.data('input')).val($this.data('value'));
    });
    $('#semester_count').on('change', function() {
        var $this = $(this);
        var $semester = $this.val()%2 ? 1 : 2;
        $('#study_subject_semester').val($semester);
        var $list = $('#pillsemester li');
        $list.map(function(){
        	if ($(this).find('a').data('value') == $semester){
        		$(this).addClass('active'); 
        	}
        	else{
        		$(this).removeClass('active');
        	}
        });
    });
});