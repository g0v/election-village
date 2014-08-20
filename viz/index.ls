main = ($scope, $http) ->
  [w,h,m] = [$(window)width!, $(window)height!, 20]
  $('#chart1').attr do
    width: w - 40
    height: h - 120
  ctx1 = $('#chart1').0.getContext \2d
  $scope.chart1 = new Chart(ctx1)
  $scope.raw = {}
  $scope.tpcolor = {}
  $scope.sxcolor = {}
  $scope.agcolor = {}

  $scope.agmap = d3.scale.linear!
    .domain [1921 1953 1987]
    .range <[#c00 #f90 #0c0]>
  $scope.sxmap = d3.scale.ordinal!
    .domain <[男 女]>
    .range <[#33b #f33]>
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
        if p.7 =>
          $scope.tpcolor[k2] = $scope.pcmap p.4
          $scope.sxcolor[k2] = $scope.sxmap p.2
          $scope.agcolor[k2] = $scope.agmap p.3
    data = do
      labels: [k for k of hash]
      datasets: [
        data: [v for k,v of hash]
      ]
    $scope.chart1.Bar(data)
    initMap \#twsvg

  $scope.showtype = 3
  initMap = (node) ->
    (data) <- d3.json \twVillage1982.topo.json
    ret = {}
    topo = topojson.feature data, data.objects["twVillage1982.geo"]
    topo.features.map ->
      it.properties.TOWNNAME = it.properties.TOWNNAME.replace /\(.+\)?\s*$/g, ""
      it.properties.name = it.properties.name.replace /\s*\(.+\)?\s*$/g, ""
      it.properties.tpc = $scope.tpcolor[it.properties.name.replace /\//g, ""]
      it.properties.sxc = $scope.sxcolor[it.properties.name.replace /\//g, ""]
      it.properties.agc = $scope.agcolor[it.properties.name.replace /\//g, ""]
    prj2 = d3.geo.mercator!center [120.979531, 24.478567] .scale 12000
    prj = ([x,y]) ->
      if x<119 => x += 1
      prj2 [x,y]
    $scope.path = d3.geo.path!projection prj
    svg = d3.select node
    $scope.svg = svg
    $scope.topo = topo
    $scope.svg.selectAll \path.village .data $scope.topo.features .enter!append \path
      .attr \class \village
      .attr \d $scope.path
    $scope.$watch 'showtype', -> 
      console.log $scope.showtype
      render!
    render!
  render = ->
    $scope.svg.selectAll \path.village
      .style \fill ->
        if $scope.showtype==3 => it.properties.sxc
        else if $scope.showtype==2 => it.properties.tpc
        else if $scope.showtype==1 => it.properties.agc
      .style \stroke ->
        if $scope.showtype==3 => it.properties.sxc
        else if $scope.showtype==2 => it.properties.tpc
        else if $scope.showtype==1 => it.properties.agc
      .style \stroke-width \0.5px
      .style \opacity 1.0
      .on \mouseover (d) -> $scope.$apply -> $scope.chosen = d.properties.name
      .on \click (d) -> $scope.$apply -> $scope.chosen = d.properties.name
