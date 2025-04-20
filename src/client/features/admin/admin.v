module admin

import veb
import shareds.wcontext
import server.features.amazon.controllers as control_amazon
import server.features.netflix.controllers as control_netflix
import server.features.instant_gaming.controllers as control_instant_gaming
import server.features.livros_gratuitos.controllers as control_livros_gratuitos
import server.features.mercado_livre_play.controllers as control_mercado_livre_play
import mf_core.context_service.models as ctx_models

// @[host: 'localhost']
fn (admin &AdminController) index(mut ctx wcontext.WsCtx) veb.Result {
	defer {
		lock ctx.obj {
			ctx.obj.current_path = '/admin/'
			ctx.obj.current_status_code = 200

			ctx.log_info({
				'path':       'PÁGINA /admin'
				'statusText': 'success'
				'additional': ctx_models.DataContext{
					infos: [
						'ip(${ctx.ip()}) | host(${ctx.req.host}) | user_agent(${ctx.req.user_agent})',
					]
				}
			})
		}
	}

	if ctx.req.host !in ['localhost:5058', 'localhost:3030', '192.168.0.100'] {
		return ctx.not_found()
	}

	return $veb.html('./view/admin.html')
}

@['/upload-jsons'; post]
fn (admin &AdminController) upload_jsons(mut ctx wcontext.WsCtx) veb.Result {
	mut status_code := 200

	defer {
		lock ctx.obj {
			ctx.obj.current_path = '/admin/upload-jsons'
			ctx.obj.current_status_code = &status_code
			ctx.obj.current_method = 'POST'

			ctx.log_info({
				'path':       'PÁGINA /admin/upload-jsons'
				'statusText': 'success'
				'additional': ctx_models.DataContext{
					infos: [
						'ip(${ctx.ip()}) | host(${ctx.req.host}) | user_agent(${ctx.req.user_agent})',
					]
				}
			})
		}
	}

	mut controller_ctx := admin.ctx

	if ctx.req.host !in ['localhost:5058', 'localhost:3030', '192.168.0.100'] {
		status_code = 404
		return ctx.not_found()
	}

	for file in ctx.files['file'] {
		if file.filename.contains('mercado_livre_play') {
			control_mercado_livre_play.import(mut controller_ctx, file.data) or {}
		} else if file.filename.contains('instantgaming') {
			control_instant_gaming.import(mut controller_ctx, file.data) or {}
		} else if file.filename.contains('amazon') {
			control_amazon.import(mut controller_ctx, file.data) or {}
		} else if file.filename.contains('netflix') {
			control_netflix.import(mut controller_ctx, file.data) or {}
		} else if file.filename.contains('livros_gratuitos') {
			control_livros_gratuitos.import(mut controller_ctx, file.data) or {}
		}
	}

	return ctx.text('success')
}
