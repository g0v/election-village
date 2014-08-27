require! <[fs]>

year-range = [20,29]
files = fs.readdir-sync \. .filter(-> it.indexOf(\.csv)>=0)
for file in files
  lines = fs.read-file-sync file .toString!split \\n .filter(->it)
  lines.splice 0,1
  lines = lines.map -> it.split \,

  for line in lines
    young = 0
    total = parseInt(line.4)
    for i from (7 + year-range.0 * 2) to (7 + year-range.1 * 2 + 1) =>
      young += parseInt(line[i])
    console.log "#young,#total,#{line.1},#{line.2}"


