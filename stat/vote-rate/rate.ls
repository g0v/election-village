require! <[fs]>


lines = fs.read-file-sync \../../data/population.csv .toString!split \\n .map -> it.split \,

hash = {}
for line in lines
  name = line.0.replace /第\d+投開票所/, ""
  if !hash[name] => hash[name] = { pop: parseInt(line.1), ballot: parseInt(line.3) + parseInt(line.4) }
  else =>
    hash[name]pop += parseInt(line.1)
    hash[name]ballot += (parseInt(line.3) + parseInt(line.4))

for name of hash =>
  hash[name]voterate = hash[name]ballot / hash[name]pop

lines = fs.read-file-sync \../../raw/population/young.csv .toString!split \\n .map -> it.split \,

for line in lines
  if !line.2 => continue
  n1 = line.2.replace(/ /g, "").replace(/臺/g, "台")
  n2 = line.3.replace(/ /g, "").replace(/臺/g, "台")
  name = "#{n1}#{n2}"
  if hash[name] =>
    hash[name].young = parseInt(line.0)
    hash[name].total = parseInt(line.1)
  else if hash[n1] =>
    if !hash[n1].young =>
      hash[n1].young = 0
      hash[n1].total = 0
    hash[n1].young += parseInt(line.0)
    hash[n1].total += parseInt(line.1)
  else
    console.log "bug: ", name

fs.write-file-sync \young-rate.json, JSON.stringify(hash)
