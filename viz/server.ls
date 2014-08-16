require! <[chokidar http fs child_process path]>

RegExp.escape = -> it.replace /[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"

ls   = if fs.existsSync v=\node_modules/.bin/livescript => v else \livescript
jade = if fs.existsSync v=\node_modules/.bin/jade => v else \jade
sass = if fs.existsSync v=\node_modules/.bin/sass => v else \sass
cwd = path.resolve process.cwd!
cwd-re = new RegExp RegExp.escape "#cwd#{if cwd[* - 1]=='/' => "" else \/}"
if process.env.OS=="Windows_NT" => [jade,sass,ls] = [jade,sass,ls]map -> it.replace /\//g,\\\

ignore-list = [/^server.ls$/, /^library.jade$/, /^\.[^/]+/, /^node_modules\//,/^assets\//]
ignore-func = (f) -> ignore-list.filter(-> it.exec f.replace(cwd-re, "")replace(/^\.\/+/, ""))length

type-table =
  "3gp":"video/3gpp",
  "aiff":"audio/x-aiff",
  "arj":"application/x-arj-compressed",
  "asf":"video/x-ms-asf",
  "asx":"video/x-ms-asx",
  "au":"audio/ulaw",
  "avi":"video/x-msvideo",
  "bcpio":"application/x-bcpio",
  "ccad":"application/clariscad",
  "cod":"application/vnd.rim.cod",
  "com":"application/x-msdos-program",
  "cpio":"application/x-cpio",
  "cpt":"application/mac-compactpro",
  "csh":"application/x-csh",
  "css":"text/css",
  "deb":"application/x-debian-package",
  "dl":"video/dl",
  "doc":"application/msword",
  "drw":"application/drafting",
  "dvi":"application/x-dvi",
  "dwg":"application/acad",
  "dxf":"application/dxf",
  "dxr":"application/x-director",
  "etx":"text/x-setext",
  "ez":"application/andrew-inset",
  "fli":"video/x-fli",
  "flv":"video/x-flv",
  "gif":"image/gif",
  "gl":"video/gl",
  "gtar":"application/x-gtar",
  "gz":"application/x-gzip",
  "hdf":"application/x-hdf",
  "hqx":"application/mac-binhex40",
  "html":"text/html",
  "ice":"x-conference/x-cooltalk",
  "ico":"image/x-icon",
  "ief":"image/ief",
  "igs":"model/iges",
  "ips":"application/x-ipscript",
  "ipx":"application/x-ipix",
  "jad":"text/vnd.sun.j2me.app-descriptor",
  "jar":"application/java-archive",
  "jpeg":"image/jpeg",
  "jpg":"image/jpeg",
  "js":"text/javascript",
  "json":"application/json",
  "latex":"application/x-latex",
  "lsp":"application/x-lisp",
  "lzh":"application/octet-stream",
  "m":"text/plain",
  "m3u":"audio/x-mpegurl",
  "m4v":"video/mp4",
  "man":"application/x-troff-man",
  "me":"application/x-troff-me",
  "midi":"audio/midi",
  "mif":"application/x-mif",
  "mime":"www/mime",
  "mkv":"  video/x-matrosk",
  "movie":"video/x-sgi-movie",
  "mp4":"video/mp4",
  "mp41":"video/mp4",
  "mp42":"video/mp4",
  "mpg":"video/mpeg",
  "mpga":"audio/mpeg",
  "ms":"application/x-troff-ms",
  "mustache":"text/plain",
  "nc":"application/x-netcdf",
  "oda":"application/oda",
  "ogm":"application/ogg",
  "pbm":"image/x-portable-bitmap",
  "pdf":"application/pdf",
  "pgm":"image/x-portable-graymap",
  "pgn":"application/x-chess-pgn",
  "pgp":"application/pgp",
  "pm":"application/x-perl",
  "png":"image/png",
  "pnm":"image/x-portable-anymap",
  "ppm":"image/x-portable-pixmap",
  "ppz":"application/vnd.ms-powerpoint",
  "pre":"application/x-freelance",
  "prt":"application/pro_eng",
  "ps":"application/postscript",
  "qt":"video/quicktime",
  "ra":"audio/x-realaudio",
  "rar":"application/x-rar-compressed",
  "ras":"image/x-cmu-raster",
  "rgb":"image/x-rgb",
  "rm":"audio/x-pn-realaudio",
  "rpm":"audio/x-pn-realaudio-plugin",
  "rtf":"text/rtf",
  "rtx":"text/richtext",
  "scm":"application/x-lotusscreencam",
  "set":"application/set",
  "sgml":"text/sgml",
  "sh":"application/x-sh",
  "shar":"application/x-shar",
  "silo":"model/mesh",
  "sit":"application/x-stuffit",
  "skt":"application/x-koan",
  "smil":"application/smil",
  "snd":"audio/basic",
  "sol":"application/solids",
  "spl":"application/x-futuresplash",
  "src":"application/x-wais-source",
  "stl":"application/SLA",
  "stp":"application/STEP",
  "sv4cpio":"application/x-sv4cpio",
  "sv4crc":"application/x-sv4crc",
  "svg":"image/svg+xml",
  "swf":"application/x-shockwave-flash",
  "tar":"application/x-tar",
  "tcl":"application/x-tcl",
  "tex":"application/x-tex",
  "texinfo":"application/x-texinfo",
  "tgz":"application/x-tar-gz",
  "tiff":"image/tiff",
  "tr":"application/x-troff",
  "tsi":"audio/TSP-audio",
  "tsp":"application/dsptype",
  "tsv":"text/tab-separated-values",
  "unv":"application/i-deas",
  "ustar":"application/x-ustar",
  "vcd":"application/x-cdlink",
  "vda":"application/vda",
  "vivo":"video/vnd.vivo",
  "vrm":"x-world/x-vrml",
  "wav":"audio/x-wav",
  "wax":"audio/x-ms-wax",
  "webm":"video/webm",
  "wma":"audio/x-ms-wma",
  "wmv":"video/x-ms-wmv",
  "wmx":"video/x-ms-wmx",
  "wrl":"model/vrml",
  "wvx":"video/x-ms-wvx",
  "xbm":"image/x-xbitmap",
  "xlw":"application/vnd.ms-excel",
  "xml":"text/xml",
  "xpm":"image/x-xpixmap",
  "xwd":"image/x-xwindowdump",
  "xyz":"chemical/x-pdb",
  "zip":"application/zip"

watch-path = \.

ctype = (name=null) ->
  ret = /\.([^.]+)$/.exec name
  return \application/octet-stream if not ret or not ret.1 or not type-table[ret.1]
  return type-table[ret.1]

ftype = ->
  switch
  | /\.ls$/.exec it => "ls"
  | /\.sass$/.exec it => "sass"
  | /\.jade$/.exec it => "jade"
  | otherwise => "other"

# assign functions to route-table for server side script routing
sample-cgi = (req, res) ->
  res.writeHead 200, {"Content-type": "text/html"}
  res.end "hello world!"
route-table = {"/sample-cgi": sample-cgi}

server = (req, res) ->
  req.url = req.url - /[?#].*$/
  file-path = path.resolve cwd, ".#{req.url}"
  if file-path.indexOf(cwd) < 0 =>
    res.writeHead 403, ctype!
    return res.end "#{req.url} forbidden"

  # custom server side script
  rel-path = file-path.replace cwd, ""
  if rel-path of route-table => return route-table[rel-path] req, res

  # directory: give index.html, or generate a list of files
  if fs.existsSync(file-path) and fs.lstatSync(file-path)isDirectory! =>
    dir = file-path.replace /\/$/,""
    file-path = "#{file-path}/index.html"
    if not fs.existsSync(file-path) =>
      files = fs.readdirSync dir
      dir = req.url.replace /\/$/,""
      res.writeHead 200, {"Content-type": \text/html}
      res.write "<h2>#{dir}<h2>\n<ul>\n"
      for it in files => res.write "<li><a href='#{dir}/#{it}'>#{it}</a></li>\n"
      return res.end \</ul>\n

  # file not exists: 404
  if not fs.existsSync(file-path) =>
    res.writeHead 404, ctype!
    return res.end "#{req.url} not found"
  console.log "[ GET ] #{file-path} (#{ctype file-path})"

  buf = fs.readFileSync file-path
  res.writeHead 200, do
    "Content-Length": buf.length
    "Content-Type": ctype file-path
  res.end buf

log = (error, stdout, stderr) -> if "#{stdout}\n#{stderr}".trim! => console.log that
update-file = ->
  [type,cmd] = [ftype(it), ""]
  if type == \other => return
  if type == \ls => cmd = "#{ls} -cb #{it}"
  if type == \sass => cmd = "#{sass} #{it} #{it.replace /\.sass$/, \.css}"
  if type == \jade => cmd = "#{jade} -P #{it}"
  if cmd =>
    console.log "[BUILD] #{cmd}"
    child_process.exec cmd, log

watcher = chokidar.watch watch-path, ignored: ignore-func, persistent: true
  .on \add, update-file
  .on \change, update-file

http.createServer server .listen 9999, \0.0.0.0

console.log "running server on 0.0.0.0:9999"
