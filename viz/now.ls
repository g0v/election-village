now = ($scope, $http) ->
  $scope.party2010 = do
    中國國民黨: 3501
    民主進步黨: 583
    綠黨: 1
    親民黨: 1
    中華統一促進黨: 2
    台灣團結聯盟: 2
    無: 10432

  $http do
    url: \now.json
    method: \GET
  .success (d) ->
    $scope.data = d
    console.log d
    key-pair = [[k,v] for k,v of $scope.data.single-rate]
    key-pair = key-pair.map -> {raw: it, rate: parseInt(1000 * ( it.1.single / it.1.all ))/10}
    key-pair.sort (a,b) -> a.rate - b.rate
    values = key-pair.map -> it.rate
    c3.generate do
      bindto: \#single-rate
      data: 
        columns: [ ["單選率"] ++ values ]
        types: 單選率: \bar
      axis:
        x: tick: format: (v) -> key-pair[v]raw.0
        y: tick: format: (v) -> "#{v}%"
    parties = [k for k of $scope.data.party]
    parties.sort (a,b) -> $scope.data.party[b] - $scope.data.party[a]
    pr2014 = [$scope.data.party[k] or 0 for k in parties]
    pr2010 = [$scope.party2010[k] or 0 for k in parties]
    parties-minor = [k for k of $scope.data.party].filter ( -> not (it in <[中國國民黨 無 民主進步黨]>))
    parties-minor.sort (a,b) -> $scope.data.party[b] - $scope.data.party[a]
    pr2014-minor = [$scope.data.party[k] or 0 for k in parties-minor]
    pr2010-minor = [$scope.party2010[k] or 0 for k in parties-minor]
    c3.generate do
      bindto: \#party-rate
      data:
        columns: [["2010年"] ++ pr2010, ["2014年"] ++ pr2014]
        type: \bar
      axis:
        x: tick: format: (v) -> parties[v]
        y: label: text: "人數"
    c3.generate do
      bindto: \#party-rate-minor
      data:
        columns: [["2010年"] ++ pr2010-minor, ["2014年"] ++ pr2014-minor]
        type: \bar
      axis:
        x: tick: format: (v) -> parties-minor[v]
        y: label: text: "人數"

    cadlist = [[k,v] for k,v of $scope.data.cadcount]
    cadlist.sort (a,b) -> b.1 - a.1
    cadlist = cadlist.splice 0,20
    cadname = cadlist.map -> it.0
    cadvalue = cadlist.map -> it.1

    c3.generate do
      bindto: \#compete
      data:
        columns: [["競爭人數"] ++ cadvalue]
        type: \bar
      axis:
        x: tick: format: (v) -> cadname[v]
        y: label: text: "人數"

    cadhash = {}
    cadlist = [[k,v] for k,v of $scope.data.cadcount]
    cadlist.sort (a,b) -> b.1 - a.1
    cadlist.map -> cadhash[it.1] = (cadhash[it.1] or 0) + 1
    cadpair = [[k,v] for k,v of cadhash]
    cadpair.sort (a,b) -> b.1 - a.1
    cadpairname = [v.0 for v in cadpair]
    cadpairvalue = [v.1 for v in cadpair]

    c3.generate do
      bindto: \#compete-stat
      data:
        columns: [["村里數"] ++ cadpairvalue]
        type: \bar
      axis:
        x: tick: {format: (v) -> cadpairname[v]}, label: text: "人數"
        y: label: text: "村里數"

    $('#party-rate svg text, #party-rate-minor svg text, #compete svg text').css do
      display: \block

