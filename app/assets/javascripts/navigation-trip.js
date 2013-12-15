$(function () {
    $('#trip').hide();
    var array = [];
    var key = 1;
    $('.navigation_trip').each(function(){
        $('#trip').show();
       var $this = $(this);
       var e = {
           'sel': $($this.data('input')),
           'content':  $this.data('content'),
           'position': $this.data('position') || 'n'
       };

        $(array).each(function(){
            var x = (this.content != e.content ? 1 : 0);
            key = key * x;
        });

        if (key == 1) array.push(e);
        key = 1;
    });

    var navigation_trip = new Trip($(array),{
        backToTopWhenEnded : true,
        skipUndefinedTrip: true,
        showNavigation: true,
        showCloseBox: true,
        delay: -1,
        nextLabel: 'далее',
        prevLabel: 'назад',
        finishLabel: 'закрыть'
    });


    $('#trip').click(function(event){
        event.preventDefault();
        if ($('.navigation_trip').length > 0) navigation_trip.start();
    });
})