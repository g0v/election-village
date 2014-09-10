require! <[fs]>
lines = fs.read-file-sync(\village.csv).toString!split(\\n).map(-> it.split \,).filter(-> it.length > 1)
party = {}
loc = {}
for line in lines
  p = line.2
  v = line.0
  if !v => console.log line
  loc[v] = ( loc[v] or 0 ) + 1
  party[p] = ( party[p] or 0 ) + 1
count = 0
county = {}
for k of loc
  c = k.substring(0,3)
  if !county[c] => county[c] = {all: 0, single: 0}
  county[c].all++
  if loc[k] == 1 => 
    county[c].single++
    count++
for k of county
  console.log k, "#{parseInt(100 * county[k].single/county[k].all)}%"
output = do
  single-rate: county
  party: party
  cadcount: loc

fs.write-file-sync \now.json, JSON.stringify(output)
