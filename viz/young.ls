young = ($scope, $http) ->
  m = 40
  $scope.rate = {}
  $http do
    url: \young-rate.json
    method: \GET
  .success (d) ->
    ret = [[k,v] for k,v of d].filter -> it.1.young
    ret.map -> it.1.youngrate = parseInt(100* (it.1.young / it.1.total)) / 100
    ret.map -> it.1.voterate = parseInt(100* it.1.voterate) / 100
    ret.sort (a,b) -> a.1.youngrate - b.1.youngrate
    #$scope.rate = ret
    data = ret.map -> {x: it.1.voterate, y: it.1.youngrate}
    voterate = data.map -> it.x
    youngrate =  data.map -> it.y
    vrscale = d3.scale.linear!domain [d3.min(voterate), d3.max(voterate)] .range [m,1000 - m]
    yrscale = d3.scale.linear!domain [d3.max(youngrate), d3.min(youngrate)] .range [m,500 - m * 2]
    d3.select \#svg .selectAll \circle .data data
      ..exit!remove!
      ..enter!append \circle
    d3.selectAll \circle
      ..attr do
        cx: -> vrscale it.x
        cy: -> yrscale it.y
        r: 5
        fill: \#f00

    xtick =  vrscale.ticks(20)
    d3.select \#svg .selectAll \g.xtick .data xtick
      ..exit!remove!
      ..enter!append \g .attr \class, \xtick
        .each (d,i) ->
          d3.select @ .append \rect .attr do
            x: -> vrscale d
            y: 460
            width: 1
            height: 10
            fill: \#000
          d3.select @ .append \text 
            ..attr do
              x: -> vrscale d
              y: 480
              "text-anchor": 'middle'
            ..text parseInt(100*d)

    ytick =  yrscale.ticks(20)
    d3.select \#svg .selectAll \g.ytick .data ytick
      ..exit!remove!
      ..enter!append \g .attr \class, \ytick
        .each (d,i) ->
          d3.select @ .append \rect .attr do
            x: 20
            y: -> yrscale d
            width: 10
            height: 1
            fill: \#000
          d3.select @ .append \text 
            ..attr do
              x: 10
              y: -> yrscale d
              "text-anchor": 'middle'
              "dominant-baseline": "central"
            ..text parseInt(100*d)
