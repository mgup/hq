module ChartHelper

  def render_distribution(name, data, options = {})
    content_tag :div, id: options[:id], style:"width: 900px; height: 500px;" do
      "<script type='text/javascript'>
        google.load('visualization', '1', {packages:['corechart']});
        google.setOnLoadCallback(drawChart);
        function drawChart() {
          var data = google.visualization.arrayToDataTable(#{[['НПР', 'Балл']] + data.map { |p| [User.find(p[0]).full_name, p[1]] }});

          var options = {
              title: '#{name}'
          };

          var chart = new google.visualization.Histogram(document.getElementById('#{options[:id]}'));
          chart.draw(data, options);
        }
    </script>".html_safe
    end

  end

end