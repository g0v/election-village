main = ($scope, $http) ->
  [w,h,m] = [$(window)width!, $(window)height!, 20]
  $('#chart1').attr do
    width: w - 40
    height: h - 120
  ctx1 = $('#chart1').0.getContext \2d
  $scope.chart1 = new Chart(ctx1)
  $http do
    url: \region.json
    method: \GET
  .success (d) -> 
    hash = {}
    for k,v of d =>
      for p in v
        if !hash[p.3]? => hash[p.3] = 0
        hash[p.3]++
    data = do
      labels: [k for k of hash]
      datasets: [
        data: [v for k,v of hash]
      ]
    $scope.chart1.Bar(data)
