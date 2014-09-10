require! <[fs]>

# calculate average age in each town
data = JSON.parse(fs.read-file-sync \region.json .toString!)

hash = {}
for k,v of data
  idx = <[鄉 區 鎮 市]>map(-> k.indexOf it)filter(->it>=3)sort!0

  name = k.substring 0, idx + 1
  p = v.filter(-> it.7).0
  if !p => continue
  age = parseInt p.3
  hash.[][name].push age

console.log hash
avgage = {}
for k,v of hash
  avg = parseInt(v.reduce(((a,b) -> a+ b), 0) / v.length)
  avgage[k] = avg

console.log avgage

[mink,minv] = ["", 2000]
[maxk,maxv] = ["", 1000]
for k,v of avgage
  if v > maxv => [maxk,maxv] = [k,v]
  if v < minv => [mink,minv] = [k,v]
console.log "最年輕: ", maxk, maxv
console.log "最老: ", mink, minv
