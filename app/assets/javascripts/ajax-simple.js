// $(function() {
//   $('.ajax-faculty').each(function() {     
//       $(this).change(function() {
//         $.getJSON(
//           'ajax/specialities', 
//           { 'faculty': $(this).val() }, 
//           function(data) {
//             var $el = $('#speciality');
//             $el.empty();

//             $el.append(
//                 $('<option></option>').attr('value', null)
//                 .text('все специальности')
//               );
//             $(data).each(function() {
//               $el.append(
//                 $('<option></option>').attr('value', this.id)
//                 .text(this.code + ' ' + this.name)
//               );
//             });

//             $el.trigger('liszt:updated');
//           }
//         );
//       });
//   });
// });