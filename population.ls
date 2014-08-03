require! <[request cheerio fs]>
url-root = \http://db.cec.gov.tw

plist = [
  <[\histQuery.jsp?voteCode=20101101V1B3&qryType=prof 直轄市]>
  <[\histQuery.jsp?voteCode=20100601S1E1&qryType=prof 非直轄市]>
]

if !(fs.exists-sync \data) => fs.mkdir \data

plist-done = if fs.exists-sync \data/plist-done.json => JSON.parse fs.read-file-sync \data/plist-done.json .toString! else {}
plist-fail = {}

download-done = ->
  if plist-fail.length >0 =>
    console.log "there are failed items:"
    for item in plist-fail => console.log "  * ", item
  else
    console.log "all data fetched."

population = {}
download = (list) ->
  target = null
  while list.length =>
    r = list.splice 0,1 .0
    if !plist-done[r.0] => 
      target = r
      break
  if !target => return download-done!
  console.log "[#{list.length} remain] Getting #{target.0} (#{target.1})"

  request {
    url: "#{url-root}/#{target.0}"
    method: \GET
  }, (e,r,b) ->
    if !e => 
      $ = cheerio.load b
      $("table tr td a").map -> list ++= [[$(@).attr(\href), $(@).text!]]
      trs = $("table tr")
      for tr in trs
        data = for it in ($(tr)find("td").map -> $(@).text!) => it.trim!replace /%/, ""
        name = data.splice 0,1 .0 .trim!
        if data.length == 14 =>
          data = data[1,8,9,10,12]
        else if data.length == 10 =>
          data = data[1,4,5,6,8]
        if name=="全國" => name = target.1
        # last member is vote rate, 0 < rate < 100. for filtering out heading rows
        rate = parseFloat(data.4)
        if !isNaN(rate) and rate < 100 => population[name] = data

      fs.write-file-sync \data/population.json, JSON.stringify(population)
      plist-done[target.0] = true
      fs.write-file-sync \data/plist-done.json, JSON.stringify(plist-done)
    else => 
      console.log "failed. skipped..."
      plist-fail[target.0] = true
    setTimeout (-> download list), parseInt(Math.random!*100) + 100

download plist
