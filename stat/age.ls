require! <[fs]>

addr-parser = /^(..[縣市])(.{1,2}[^鄉鎮市區]?[鄉鎮市區])(.{1,9}[里村])$/

region = JSON.parse(fs.read-file-sync \region.json .toString!)
hash = {}

for k,v of region
  ret = /^(..[縣市])(.{1,2}[^鄉鎮市區]?[鄉鎮市區])(.{1,9}[里村])$/.exec k
  ret = addr-parser.exec k
  v1 = ret.1
  v2 = ret.1 + ret.2
  if !hash[v1] => hash[v1] = {total: 0}
  if !hash[v2] => hash[v2] = {total: 0}
  for it in v
    year = it.3 - 1921
    if !hash[v1][year] => hash[v1][year] = 0
    hash[v1][year]++
    if !hash[v2][year] => hash[v2][year] = 0
    hash[v2][year]++

fs.write-file-sync \age-detail.json, JSON.stringify(hash)

labels = [y for y from 1921 to 1988]

datasets = for label,v of hash
  data = [(v[y - 1921] or 0) for y in labels]
  {label, data}

data = do
  labels: labels
  datasets: datasets

fs.write-file-sync \age-chart.json, JSON.stringify(data)

labels = ["#{y}-#{y+9}" for y from 25 to 85 by 10]
hash-group = {}
for k,v of hash
  hash-group[k] = [0,0,0,0,0,0,0]
  for y,c of v
    y = parseInt(y)
    idx = parseInt(((2015 - y - 1921) - 25) / 10)
    hash-group[k][idx] += c

datasets = for label, v of hash-group => {label, data: v}

data = do
  labels: labels
  datasets: datasets

fs.write-file-sync \age-chart-group.json, JSON.stringify(data)
