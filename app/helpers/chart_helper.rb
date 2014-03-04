module ChartHelper

  def render_chart(name, data, options = {})
    content_tag :div, id: "chart_div", style:"width: 900px; height: 500px;" do
      "'<script type='text/javascript'>
        google.load('visualization', '1', {packages:['corechart']});
        google.setOnLoadCallback(drawChart);
        function drawChart() {
          var data = google.visualization.arrayToDataTable(#{data});

          var options = {
              title: '#{name}'
          };

          var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
          chart.draw(data, options);
        }
    </script>'" .html_safe
    end

  end

end