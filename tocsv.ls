require! <[fs]>

region = JSON.parse(fs.read-file-sync \data/region.json .toString!)
line = [ "選區,姓名,號次,性別,出生年次,推薦政黨,得票數,得票率,當選,現任" ]
for k,v of region
  for p in v
    line ++= ["#k,#{p.0},#{p.1},#{p.2},#{p.3},#{p.4},#{p.5},#{p.6},#{p.7},#{p.8}"]

fs.write-file-sync "data/region.csv", line.join \\n

population = JSON.parse(fs.read-file-sync \data/population.json .toString!)
line = [ "選舉人數,投票數,有效票數,無效票數,投票率" ]
for k,v of population
    line ++= ["#k,#{v.join \,}"]

fs.write-file-sync "data/population.csv", line.join \\n
