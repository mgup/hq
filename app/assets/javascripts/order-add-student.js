$(function(){
	('.orderadd').click(function() {
        $this = $(this);
        $student = $(this).data('value');
        var params = 'student=' + $student;
        $.ajax({
            url: '/new',
            data: params
        });
    });
})