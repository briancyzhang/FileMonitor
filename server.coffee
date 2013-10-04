fs = require('fs')
path = require('path')
http = require('http')

folder = process.argv[2] || "C:\\node\\filemonitor\\test"

port = process.argv[3] || 8080

c = []

cb = -> 
	c = []
	require('file').walk folder, (x, dirPath, dirs, names) ->
		names.forEach (file) ->		
			fs.stat file, (err, stat) ->
				o =
					path: path.relative(folder, file)
					mtime: stat.mtime
				c.push o			

setInterval cb, 5000

svc = http.createServer (req,res) ->
	res.end JSON.stringify(c)

svc.listen(port)