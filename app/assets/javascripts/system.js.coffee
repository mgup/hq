@initServerStatsGauge = (id, title, height = 200) ->
  $(id).highcharts
    chart:
      type: 'gauge'
      height: height
      animation: false
    title:
      text: title
    pane:
      startAngle: if 200 == height then -130 else -110
      endAngle  : if 200 == height then 130 else 110
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

@updateGaugeExtremes = (name, min, max, value) ->
  chart = $("##{name}").highcharts()
  axe = chart.yAxis[0]
  axe.setExtremes min, max
  axe.removePlotBand 'green'
  axe.removePlotBand 'yellow'
  axe.removePlotBand 'red'
  bands = [
    {id: 'green',  from: min,                      to: min + 0.5 * (max - min),  color: '#55BF3B'},
    {id: 'yellow', from: min + 0.5 * (max - min),  to: min + 0.75 * (max - min), color: '#DDDF0D'},
    {id: 'red',    from: min + 0.75 * (max - min), to: max,                      color: '#DF5353'}
  ]
  axe.addPlotBand(band) for band in bands
  chart.series[0].setData([parseFloat(value.toFixed(2))])