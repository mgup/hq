updateInflections = (field) ->
  input = $("#{field}_ip")
  input.on 'blur', ->
    $.getJSON '/utility/morpher', { word: input.val() }, (response) ->
      $("#{field}_ip").val(response[0]);
      $("#{field}_rp").val(response[1]);
      $("#{field}_dp").val(response[2]);
      $("#{field}_vp").val(response[3]);
      $("#{field}_tp").val(response[4]);
      $("#{field}_pp").val(response[5]);

$ ->
  updateInflections('#user_last_name')
  updateInflections('#user_first_name')
  updateInflections('#user_patronym')