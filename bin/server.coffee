connect = require("connect")
Mincer = require("mincer")
Template  = Mincer.Template
autoprefixer = require('autoprefixer')

class AutoPrefix extends Template
	evaluate: (context, locals, callback)->
		callback null, autoprefixer.compile @data

Mincer.registerPostProcessor('text/css', AutoPrefix)

environment = new Mincer.Environment()
environment.appendPath('site')
environment.appendPath('core')
environment.appendPath('components')
environment.appendPath('themes')
environment.appendPath('vendor')
environment.appendPath('specs')

app = connect()
app.use "/", connect.static process.cwd()+"/site"
app.use connect.static process.cwd()
app.use "/assets", Mincer.createServer(environment)
app.listen(process.env.PORT || 4000)

console.log 'MUI running on port 4000...'