$(function(){
    $(document).on('nested:fieldAdded', function(event){
        var field = event.field;
        var dateField = field.find('.datepicker');
        dateField.datepicker();
    })
})