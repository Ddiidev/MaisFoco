module admin

import veb
import shareds.logger
import shareds.wcontext
import server.features.amazon.controllers as control_amazon
import server.features.netflix.controllers as control_netflix
import server.features.instant_gaming.controllers as control_instant_gaming
import server.features.livros_gratuitos.controllers as control_livros_gratuitos
import server.features.mercado_livre_play.controllers as control_mercado_livre_play

// @[host: 'localhost']
fn (admin &AdminController) index(mut ctx wcontext.WsCtx) veb.Result {
	if ctx.req.host !in ['localhost:5058', 'localhost:3030', '192.168.0.100'] {
		return ctx.not_found()
	}

	return $veb.html('./view/admin.html')
}

@['/upload-jsons'; post]
fn (admin &AdminController) upload_jsons(mut ctx wcontext.WsCtx) veb.Result {
	if ctx.req.host !in ['localhost:5058', 'localhost:3030', '192.168.0.100'] {
		return ctx.not_found()
	}

	mut log := logger.Logger.new('./logs', 'log')
	log.info('upload_jsons')

	for file in ctx.files['file'] {
		if file.filename.contains('mercado_livre_play') {
			log.info('importando mercado livre "${file.filename}"')

			control_mercado_livre_play.import(mut log, file.data) or { log.error(err.str()) }
		} else if file.filename.contains('instantgaming') {
			log.debug('importando instant gaming "${file.filename}"')

			control_instant_gaming.import(mut log, file.data) or { log.error(err.str()) }
		} else if file.filename.contains('amazon') {
			log.debug('importando amazon "${file.filename}"')

			control_amazon.import(mut log, file.data) or { log.error(err.str()) }
		} else if file.filename.contains('netflix') {
			log.debug('importando netflix "${file.filename}"')

			control_netflix.import(mut log, file.data) or { log.error(err.str()) }
		} else if file.filename.contains('livros_gratuitos') {
			log.debug('importando livros_gratuitos "${file.filename}"')

			control_livros_gratuitos.import(mut log, file.data) or { log.error(err.str()) }
		}
	}

	return ctx.text('success')
}
