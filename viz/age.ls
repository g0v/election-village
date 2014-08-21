age = ($scope, $http, $timeout) ->
  [w,h,m] = [$(window)width!, $(window)height!, 20]
  $('#chart1').attr do
    width: w - 40
    height: h - 120
  ctx1 = $('#chart1').0.getContext \2d
  $scope.color = color = d3.scale.category20!
  $scope.chart1 = new Chart(ctx1)
  $scope.raw = {}
  $scope.type = 1
  $scope.$watch 'type', (v) -> if v => $scope.load!
  $scope.stackmap = d3.scale.linear!domain [0 1] .range [0 1000]
  $scope.stack = (v) ->
    console.log v
    d = {} <<< v
    for set in d.datasets
      sum = set.data.reduce(((a,b) -> a + b),0)
      acc = 0
      ret = []
      for i from 0 til 6
        ret ++= [{acc: $scope.stackmap(acc/sum), value: $scope.stackmap(set.data[i]/sum)}]
        acc += set.data[i]
      set.data = ret
    d.datasets.sort (a,b) -> a.data.3.value - b.data.3.value
    console.log d
    d3.select \body .selectAll \svg.stack .data d.datasets
      ..exit!remove!
      ..enter!append \svg .attr do
        "viewBox": "0 0 1000 100"
        "class": "stack"
    d3.selectAll \svg.stack .each (d,i) ->
      d3.select @ .selectAll \rect .data d.data
        ..exit!remove!
        ..enter!append \rect .attr do
          x: -> it.acc
          y: 0
          width: -> it.value
          height: 100
          fill: (d,i) -> color i
    d3.select \body .selectAll \svg .append \text
      ..attr do
        y: 20
        x: 10
      ..text -> it.label


  $scope.load = ->
    $http do
      url: if $scope.type == 1 => \age-chart-group.json else \age-chart.json
      method: \GET
    .success (chd) ->
      if $scope.type == 1 => $scope.stack chd
    $http do
      url: if $scope.type == 1 => \age-chart-group.json else \age-chart.json
      method: \GET
    .success (chd) ->
      chd.datasets = chd.datasets.filter(-> it.label.length > 3 and Math.random! > (if $scope.type==1 => 0.9 else 0.97))
      chd.datasets.map ->
        c = color it.label
        it <<< do
          fillColor: c
          strokeColor: c
          pointColor: c
          pointStrokeColor: c
      $scope.chart1.Line chd, do
        bezierCurveTension: 0.2
        animation: false
        datasetFill: false
        multiTooltipTemplate:"<%= datasetLabel %> - <%= value %>"
    .error (e) -> console.error e
