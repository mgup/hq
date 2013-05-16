@initServerMonitorChart = (id, title) ->
  $(id).highcharts
    chart:
      type: 'gauge'
      height: 200
    title:
      text: title
    pane:
      startAngle: -150
      endAngle  : 150
      background:
        backgroundColor: '#FFF'
    yAxis:
      min: 0
      max: 6
      minorTickColor: '#666'
      tickColor: '#666'
      plotBands: [{
        id: 'green', from: 0, to: 2, color: '#55BF3B'
      }, {
        id: 'yellow', from: 2, to: 4, color: '#DDDF0D'
      }, {
        id: 'red', from: 4, to: 6, color: '#DF5353'
      }]
    series: [{
      data: [0]
    }]
    tooltip:
      enabled: false
    credits:
      enabled: false

