connect = require("connect")
Mincer = require("mincer")
Template  = Mincer.Template
jade = require('jade')
autoprefixer = require('autoprefixer')

class JadeEngine extends Template
	evaluate: (context, locals, callback)->
		try
			fn = jade.compile(@data,{filename: @file})
			callback null, fn()
		catch e
			callback e

Object.defineProperty JadeEngine, 'defaultMimeType', {value: 'text/html'}

class AutoPrefix extends Template
	evaluate: (context, locals, callback)->
		callback null, autoprefixer.compile @data


Mincer.registerMimeType('text/html', '.html')
Mincer.registerPreProcessor('text/html',Mincer.DirectiveProcessor)
Mincer.registerEngine '.jade', JadeEngine
Mincer.registerPostProcessor('text/css', AutoPrefix)

environment = new Mincer.Environment()
environment.appendPath('views')
environment.appendPath('core')
environment.appendPath('components')
environment.appendPath('themes')
environment.appendPath('vendor')
environment.appendPath('specs')

app = connect()
app.use connect.static process.cwd()
app.use "/", Mincer.createServer(environment)
app.listen(process.env.PORT || 4000)