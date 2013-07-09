$(function() {
    $('.pill-select a[data-toggle="pill"]').on('shown.bs.tab', function() {
        var $this = $(this);
        $('#' + $this.data('input')).val($this.data('value'));
    });
    $('#semester_count').on('change', function() {
        var $this = $(this);
        if ((+$this.val() > 12) || (+$this.val() < 1) ||
            (+$this.val() != parseInt($this.val()))){
            $this.val('');
        }
        else {
            var $semester = $this.val()%2 ? 1 : 2;
            var $course = (+$this.val() + ($this.val()%2))/2;
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
            $('input#course_study').val($course);
            var $li = $('#pillcourse li');
            $li.map(function(){
                if ($(this).find('a').data('value') == $course){
                    $(this).addClass('active'); 
                    $(this).find('a').trigger('shown.bs.tab');
                }
                else{
                    $(this).removeClass('active');
                }
            });
        }
    });
});