es                    = require 'event-stream'
getScriptSources      = require('../utils').getScriptSources
{COMPONENTS_DIRECTORY,
	TEMP_DIRECTORY,
	SRC_DIRECTORY}    = require '../constants'
templateOptions       = require '../templateOptions'

module.exports = (gulp, plugins) -> ->
	{onError} = require('../events') plugins
	sources = getScriptSources '.ts'
	srcs    = []

	srcs.push src =
		gulp
			.src sources, {cwd: SRC_DIRECTORY, nodir: true}
			.on 'error', onError

			.pipe plugins.template templateOptions
			.on 'error', onError

	srcs.push src =
		gulp
			.src sources, {cwd: COMPONENTS_DIRECTORY, nodir: true}
			.on 'error', onError

			.pipe gulp.dest TEMP_DIRECTORY
			.on 'error', onError

	es
		.merge.apply @, srcs
		.on 'error', onError

		.pipe plugins.newer TEMP_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError

		.pipe plugins.typescript()
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError
