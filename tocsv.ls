require! <[fs]>

region = JSON.parse(fs.read-file-sync \data/region.json .toString!)
console.log "選區,姓名,號次,性別,出生年次,推薦政黨,得票數,當選,現任"
for k,v of region
  for p in v
    console.log "#k,#{p.0},#{p.1},#{p.2},#{p.3},#{p.4},#{p.5},#{p.6},#{p.7},#{p.8}"
