//$(function(){
//    $('.control_max').each( function(){
//        var $this = $(this);
//        $this.change( function(){
//            var $min = 0;
//            var $max = 0;
//            $('.control_min').map(function(){
//                $min+=parseInt($(this).val());
//            })
//            $('.control_max').map(function(){
//                $max+=parseInt($(this).val());
//            })
//            $el = $('#max')
//            $el.empty();
//            $el.append($max);
//            if ($max != 80 || $min != 44) {
//                $('#minmax_info').removeClass('alert-success')
//                                 .addClass('alert-danger');
//            }
//            else{
//                $('#minmax_info').removeClass('alert-danger')
//                    .addClass('alert-success');
//            }
//            $el.trigger('liszt:updated');
//        })
//    });
//    $('.control_min').each( function(){
//        var $this = $(this);
//        $this.change( function(){
//            var $min = 0;
//            var $max = 0;
//            $('.control_min').map(function(){
//                $min+=parseInt($(this).val());
//            })
//            $('.control_max').map(function(){
//                $max+=parseInt($(this).val());
//            })
//            $el = $('#min')
//            $el.empty();
//            $el.append($min);
//            if ($max != 80 || $min != 44){
//                $('#minmax_info').removeClass('alert-success')
//                    .addClass('alert-danger');
//            }
//            else{
//                $('#minmax_info').removeClass('alert-danger')
//                    .addClass('alert-success');
//            }
//            $el.trigger('liszt:updated');
//        })
//    })
//})