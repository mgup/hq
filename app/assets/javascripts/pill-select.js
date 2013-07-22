$(function() {
    $('.pill-select a[data-toggle="pill"]').on('shown.bs.tab', function() {
        var $this = $(this);
        $('#' + $this.data('input')).val($this.data('value')).change();
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
    $('#course_study').on('change', function() {
      var $this = $(this);
      var $course = (+$this.val())*2
      var $semester = +$('#study_subject_semester').val()%2;
      $('#semester_count').val($course-$semester);
    });
    $('#study_subject_semester').on('change', function() {
      var $this = $(this);
      var $course = (+$('#course_study').val())*2
      var $semester = +$this.val()%2;
      $('#semester_count').val($course-$semester);
    });
    $('#allmarks').on('change', function(){
        $mark = $(this).val()
        $('.all_mark').val($mark).change();
        var $limarks = $('#pillmark li');
        $limarks.map(function(){
            if ($(this).find('a').data('value') == $mark){
                $(this).addClass('active'); 
                $(this).find('a').trigger('shown.bs.tab');
            }
            else{
                $(this).removeClass('active');
            }
        });
    });
    $('.all_mark').map(function () {
      $(this).attr('oldValue', $(this).val());
    });
    $('.all_mark').map( function () {
      $(this).on('change', function(){
        $elem = $('#mark' + $(this).val()) 
        $counter = +$elem.val()+1
        $elem.val($counter);
        var oldValue = $(this).attr('oldValue');
          if (oldValue != ''){
            $('#mark' + oldValue).val(+$('#mark' + oldValue).val()-1);
           }
        $(this).attr('oldValue', $(this).val());
      });
    });
    // $('#study_discipline_semester').on('change', function() {
    //   var $this = $(this);
    //   var $li = $('#pillsem li');
    //   $li.map(function(){
    //             if ($(this).find('a').data('value') == $this.val()){
    //                 $(this).addClass('active'); 
    //                 $(this).find('a').trigger('shown.bs.tab');
    //             }
    //             else{
    //                 $(this).removeClass('active');
    //             }
    // });
});