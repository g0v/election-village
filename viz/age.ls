age = ($scope, $http) ->
  [w,h,m] = [$(window)width!, $(window)height!, 20]
  $('#chart1').attr do
    width: w - 40
    height: h - 120
  ctx1 = $('#chart1').0.getContext \2d
  color = d3.scale.category20!
  $scope.chart1 = new Chart(ctx1)
  $scope.raw = {}
  $scope.type = 1
  $scope.$watch 'type', (v) -> if v => $scope.load!
  $scope.load = ->
    $http do
      url: if $scope.type == 1 => \age-chart-group.json else \age-chart.json
      method: \GET
    .success (chd) ->
      chd.datasets = chd.datasets.filter(-> it.label.length > 3 and Math.random! > (if $scop.type==1 => 0.9 else 0.97))
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
