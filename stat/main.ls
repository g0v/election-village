require! <[fs]>

data = JSON.parse(fs.read-file-sync \region.json .toString!)

age1 = {}
age2 = {}
for k,v of data
  i = k.indexOf "區"
  if i<0 => i = k.indexOf "鄉"
  if i<0 => i = k.indexOf "鎮"
  if i > 6 => i = 6
  k2 = k.substring(0,i + 1)
  age1[k2] = []
  age2[k2] = []
for k,v of data
  i = k.indexOf "區"
  if i<0 => i = k.indexOf "鄉"
  if i<0 => i = k.indexOf "鎮"
  if i > 6 => i = 6
  k2 = k.substring(0,i + 1)
  for p in v
    age1[k2].push p.3
    if p.7 => age2[k2].push p.3


/*
for k,v of age1
  sum = v.reduce(((a,b) -> a+b), 0)
  avg = parseInt(sum / v.length)
  console.log(k, avg)
*/

for k,v of age2
  sum = v.reduce(((a,b) -> a+b), 0)
  avg = parseInt(sum / v.length)
  console.log(k, avg)

