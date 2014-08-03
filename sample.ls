require! <[fs]>

region = JSON.parse(fs.read-file-sync \data/region.json .toString!)


filter = {}

cumulate = (idx, item) ->
  if !filter.{}[idx][item[idx]] => filter.{}[idx][item[idx]] = 0
  filter[idx][item[idx]]++
for k,list of region
  for item in list => [2 3 4]map -> cumulate it, item

console.log "全國村里長各面向基本比例"
console.log "============"
console.log ""
console.log "出生年次分佈"
console.log "------------"
console.log ""
[max-idx, max-val] = [0, 0]
for k,v of filter.3
  if v > max-val => [max-idx, max-val] = [k, v]
  console.log "  * #k : #v 人"
console.log "最多人(#max-val) 出生的年次: #max-idx"
console.log "------------"
console.log ""
console.log "男女比例"
console.log "------------"
console.log "男性:女性 = #{filter.2.'男'} : #{filter.2.'女'}"
console.log ""
console.log "政黨別分佈"
console.log "------------"
for k, v of filter.4
  console.log "  * #k : #v 人"
