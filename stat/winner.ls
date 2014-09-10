require! <[fs]>

region = JSON.parse(fs.read-file-sync \region.json)

hash = {}
for k,v of region
  for it in v => if it.7 => hash[k] = it.4

fs.write-file-sync \winner.json, JSON.stringify(hash)
