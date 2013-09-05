$(function () {
    var array = [];
    $('.navigation_trip').each(function(){
       var $this = $(this);
        array.push({
            'sel': $($this.data('input')),
            'content':  $this.data('content')
        });
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

    $('#trip').click(function(){
        navigation_trip.start();
    });
})