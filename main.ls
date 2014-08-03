require! <[request cheerio fs]>
url-root = \http://db.cec.gov.tw
index-page = [
  \http://db.cec.gov.tw/histQuery.jsp?voteCode=20101101V1B3&qryType=ctks # 直轄里
  \http://db.cec.gov.tw/histQuery.jsp?voteCode=20100601S1E1&qryType=ctks # 一般村
]

if !(fs.exists-sync \data) => fs.mkdir \data

vlist = []
fetch-list = (list) ->
  if list.length == 0 => 
    fs.write-file-sync \vlist.json, JSON.stringify vlist
    console.log "index page analyzed, total #{vlist.length} page links"
    download vlist
    return
  target = list.splice 0,1 .0

  request {
    url: target
    method: \GET
  }, (e,r,b)->
    if e => return console.error "failed to fetch : ", target
    $ = cheerio.load b
    ret = for item in $("table td a").map((i,e)-> return [[$(e)attr(\href),$(e)text!]]) => item
    vlist ++= ret
    setTimeout -> fetch-list list, 100
fetch-list index-page

vlist-done = if fs.exists-sync \data/vlist-done.json => JSON.parse fs.read-file-sync \data/vlist-done.json .toString! else {}
vlist-fail = {}

download-done = ->
  if vlist-fail.length >0 =>
    console.log "there are failed items:"
    for item in vlist-fail => console.log "  * ", item
  else
    console.log "all data fetched."

region = {}
download = (list) ->
  target = null
  while list.length =>
    r = list.splice 0,1 .0
    if !vlist-done[r.0] => 
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
      trs = $("table tr")
      current-region = ""
      for tr in trs =>
        first = $(tr)find("td:first-of-type a")
        rowspan = $(tr)find("td:first-of-type").attr("rowspan")
        if rowspan => current-region = first.text!
        if !current-region => continue
        data = for it in ($(tr)find("td").map -> $(@).text!) => it.trim!
        if rowspan => data.splice 0,1
        if !region[current-region] => region[current-region] = []
        [1 3 5]map -> data[it] = parseInt data[it]
        data.7 = if data.7 => true else false
        data.6 = parseFloat(data.6.replace /%/, 0)
        region[current-region] ++= [data]
      fs.write-file-sync \data/region.json, JSON.stringify(region)
      vlist-done[target.0] = true
      fs.write-file-sync \data/vlist-done.json, JSON.stringify(vlist-done)
    else => 
      console.log "failed. skipped..."
      vlist-fail[target.0] = true
    setTimeout (-> download list), parseInt(Math.random!*100) + 100
