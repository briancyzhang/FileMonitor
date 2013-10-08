fs = require('fs')
path = require('path')
http = require('http')
url = require('url');

folder = process.argv[2] || "C:\\node\\filemonitor\\test"

port = process.argv[3] || 8080

c = []

cb = -> 
	c = []
	require('file').walk folder, (x, dirPath, dirs, names) ->
		names.forEach (file) ->		
			fs.stat file, (err, stat) ->
				o =
					file: file
					path: path.relative(folder, file)
					mtime: stat.mtime
				c.push o			

setInterval cb, 5000

svc = http.createServer (req,res) ->
	p = url.parse req.url, true
	t = p.query.term
	x = c
	if t
		x = x.filter (e) ->
			return e.file.indexOf(t) >= 0
	res.end JSON.stringify(x)

svc.listen(port)