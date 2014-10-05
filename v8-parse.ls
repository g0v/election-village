require! <[fs fast-csv]>

# exception
# 第6.7.8屆, ...
# 第七屆長,

r1 = (it, a)->
  if a.4 == "李　秀男" =>
    console.log it
  r = [
    [/[零０]/g, "0"],
    [/[一１]/g, "1"],
    [/[二２]/g, "2"],
    [/[三３]/g, "3"],
    [/[四４]/g, "4"],
    [/[五５]/g, "5"],
    [/[六６]/g, "6"],
    [/[七７]/g, "7"],
    [/[八８]/g, "8"],
    [/[九９]/g, "9"],
    [/(\D)十(\D)/g, "$110$2"],
    [/(\D)十(\d)/g, "$11$2"],
    [/(\d)十(\D)/g, "$10$2"],
    [/(\d)十(\d)/g, "$1$2"]
  ]
  for p in r =>
    it = it.replace p.0, p.1
  if a.4 == "李　秀男" =>
    console.log it
  p = /[第地]?(([0-9]+屆?[、._~-]?)+)任?(..[區鄉鎮市])?[村里]長/
  ret = p.exec it
  if !ret => return null
  raw = ret.0
  v = ret.1
  v = v.replace /[第地屆]/g, ""
  v = v.replace /[、.]/g, "." 
  if /\.$/.exec v => 
    return null
  v = v.replace /[_~-]/g, "~" 
  if /\d+[_~-]\d+/.exec v =>
    v = v.split(\~)filter(->it)map(->parseInt(it))
    v = [i for i from v.0 to v.1]
    console.log v, "(range)", raw, a.4
    return v
  else =>
    v = v.split(\.)filter(->it)map(->parseInt(it))
    console.log v, "discrete", raw, a.4
    return v
  return null

r2 = ->
  ret = /里里長/.exec it
  #console.log it
  if !ret => return null
  return "曾任"

r3 = ->
  ret = /^([專現新][任職])?里長$/.exec it
  if ret => return "曾任"
  ret = /[.、 ]?([專現新][任職])?里長$/.exec it
  if ret => return "曾任"
  ret = /^([專現新][任職])?里長[.、 ]/.exec it
  if ret => return "曾任"
  ret = /[.、 ]([專現新][任職])?里長[.、 ]/.exec it
  if ret => return "曾任"
  return null


ppat = [r1, r2, r3]
range = (src, a) ->
  if !src => return
  ret = /[屆村里]長/.exec src
  if !ret => return
  str = "#src"
  matched = null
  for p in ppat =>
    ret = p str, a
    if ret => matched = ret
  return matched
  #  if !matched =>
  #  console.log "~", src
    #if src == "里長" => console.log a.15

edu = ->
  pat = [
    [/小學|國小|國中/, 1]
    [/國[（_]初[）_]中|國民中學|國中|初中|初級中學/, 2]
    [/水產職業|高級農業|農工|高農|高級商業|一中|工商|高級中學|高工|高商|商工|商職|高中|高職|專科|女中/, 3]
    [/藥專|師專|三專|二專|五專/, 4]
    [/體專|工專|大學|大專|學院/, 5]
    [/碩士/, 6]
    [/博士/, 7]
    [/海軍陸戰隊|常士班|士官|士校|官校/, 8]
    # 9: undefined
  ]
  matched = null
  complete = true
  for p in pat => 
    ret = p.0.exec it
    if ret => 
      matched = p.1
  if !matched and (!it or !it.trim!) => matched = 9
  if matched =>
    if /肄業/.exec it => complete = false
    #console.log p.1, complete
  else 
    console.log "unmatched: ", it

lines = []
#lines = fs.read-file-sync \data/v8.csv .toString!split \\n
stream = fs.createReadStream \data/v8.csv
csvStream = fast-csv!
  ..on \data, (d) ->
    lines.push d
  ..on \end, ->
    for line in lines
      if line.1 != "台北市" => continue
      ret = range line.12, line
      line.push if ret => ret else null
    ret = lines.map(->
      it.map(-> 
        if it =>'"' + it + '"' else '""'
      ).join(",")
    ).join("\n")
    fs.write-file-sync \v8.gen.csv, ret
stream.pipe csvStream
