main = ($scope, $http) ->
  [w,h,m] = [$(window)width!, $(window)height!, 20]
  $('#chart1').attr do
    width: w - 40
    height: h - 120
  ctx1 = $('#chart1').0.getContext \2d
  $scope.chart1 = new Chart(ctx1)
  $scope.raw = {}
  $scope.tpcolor = {}
  $scope.tpcount = {}
  $scope.pcmap = d3.scale.ordinal!
    .domain <[無黨籍及未經政黨推薦 中國國民黨 民主進步黨 綠黨 親民黨 中華統一促進黨 台灣團結聯盟 無]>
    .range <[#999 #009 #0c0 #9c9 #f90 #f00 #990 #999]>
  $http do
    url: \region.json
    method: \GET
  .success (d) -> 
    $scope.raw = d
    hash = {}
    for k,v of d =>
      k2 = k.replace /臺/, "台"
      for p in v
        if !hash[p.3]? => hash[p.3] = 0
        hash[p.3]++
        if p.7 => $scope.tpcolor[k2] = $scope.pcmap p.4
    data = do
      labels: [k for k of hash]
      datasets: [
        data: [v for k,v of hash]
      ]
    $scope.chart1.Bar(data)
    initMap \#twsvg

  initMap = (node) ->
    (data) <- d3.json \twVillage1982.topo.json
    ret = {}
    topo = topojson.feature data, data.objects["twVillage1982.geo"]
    topo.features.map ->
      it.properties.TOWNNAME = it.properties.TOWNNAME.replace /\(.+\)?\s*$/g, ""
      it.properties.name = it.properties.name.replace /\s*\(.+\)?\s*$/g, ""
      it.properties.c = $scope.tpcolor[it.properties.name.replace /\//g, ""]
    prj2 = d3.geo.mercator!center [120.979531, 24.478567] .scale 12000
    prj = ([x,y]) ->
      if x<119 => x += 1
      prj2 [x,y]
    path = d3.geo.path!projection prj
    svg = d3.select node
    svg.selectAll \path.town .data topo.features .enter!append \path
      .attr \class \town
      .attr \d path
      .style \fill -> it.properties.c
      .style \stroke -> it.properties.c
      .style \stroke-width \0.5px
      .style \opacity 1.0
      .on \mouseover (d) -> $scope.$apply -> $scope.chosen = d.properties.name
      .on \click (d) -> $scope.$apply -> $scope.chosen = d.properties.name
