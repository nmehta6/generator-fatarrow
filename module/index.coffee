_      = require 'underscore'
_.str  = require 'underscore.string'
chalk  = require 'chalk'
logo   = require 'fatarrow-ascii-art'
path   = require 'path'
yeoman = require 'yeoman-generator'

check     = chalk.green '✓'
NamedBase = yeoman.generators.NamedBase

class ModuleGenerator extends NamedBase
	init: ->
		@on 'end', ->
			@log logo
			@log()
			@log chalk.magenta "Module '#{@name}' created!"
			@log()

	splash: ->
		@log logo
		@log chalk.magenta 'Get ready to create your fatarrow module!'
		@log()

	askFor: ->
		done = @async()

		prompts = [
			name    : 'features'
			type    : 'checkbox'
			message : 'What would you like to include?'
			choices: [
				value   : 'includeController'
				name    : 'Controller'
				checked : true
			,
				value   : 'includeRoute'
				name    : 'Route'
				checked : true
			,
				value   : 'includeService'
				name    : 'Service'
				checked : true
			]
		]

		hasFeature = (features, feature) ->
			features.indexOf(feature) isnt -1

		@prompt prompts, ((props) ->
			features           = props.features
			@includeController = hasFeature features, 'includeController'
			@includeRoute      = hasFeature features, 'includeRoute'
			@includeService    = hasFeature features, 'includeService'

			done()
		).bind this

	names: ->
		normalized      = _.str.underscored @name
		dasherized      = _.str.dasherize normalized
		@className      = _.str.classify normalized
		moduleName      = _.str.camelize normalized
		@directory      = path.join 'src', moduleName
		@controllerName = "#{moduleName}Controller"
		@controllerPath = path.join @directory, @controllerName + '.coffee'
		routeName       = "#{moduleName}Routes"
		@routePath      = path.join @directory, routeName + '.coffee'
		@routeUrl       = path.join '/', dasherized
		@serviceName    = "#{moduleName}Service"
		@servicePath    = path.join @directory, @serviceName + '.coffee'
		@viewName       = path.join '/', moduleName, dasherized + '.html'
		@viewPath       = path.join @directory, dasherized + '.html'

		console.log 'VIEW NAME', @viewName
		console.log 'VIEW PATH', @viewPath
		console.log 'CLASS NAME', @className
		console.log 'DASHERIZED', dasherized




		# # @className      = _.str.classify normalized
		# moduleName      = _.str.camelize normalized
		# @controllerName = "#{moduleName}Controller"
		# @serviceName    = "#{moduleName}service"
		# directory       = "src/#{moduleName}"
		# @routeName      = "/#{normalized }"
		# @viewName       = "#{normalized }.html"
		# @viewUrl        = "/#{moduleName}/#{@viewName}"
		# @viewPath       = "#{directory}/#{@viewName}"
		# @controllerPath = "#{directory}/#{moduleName}Controller.coffee"
		# @servicePath    = "#{directory}/#{moduleName}Service.coffee"
		# @routesPath     = "#{directory}/#{moduleName}Routes.coffee"

	scaffold: ->
		@log '\n', chalk.magenta 'Tree:'
		@mkdir @directory

		if @includeController
			@copy 'src/module/moduleController.coffee', @controllerPath

		if @includeRoute
			@copy 'src/module/moduleRoutes.coffee', @routePath
			@copy 'src/module/module.html', @viewPath

		if @includeService
			@copy 'src/module/moduleService.coffee', @servicePath

module.exports = ModuleGenerator