module user_recomendation

import veb
import shareds.wcontext
import shareds.components.footer
import client.features.user_recomendation.views
import mf_core.log_observoo.models as log_models
import server.features.user_recomendation.controllers
import mf_core.context_service.models as ctx_models

@['/'; post]
pub fn (ur &UserRecomendation) send_confirmation(mut ctx wcontext.WsCtx) veb.Result {
	mut status_code := 200
	defer {
		lock ctx.obj {
			ctx.obj.current_path = '/api/v1/user-recomendation/'
			ctx.obj.current_status_code = &status_code
			ctx.obj.current_method = 'POST'

			ctx.log_info({
				'path':       'PÁGINA /api/v1/user-recomendation/'
				'statusText': 'success'
				'additional': ctx_models.DataContext{
					infos: [
						'ip(${ctx.ip()}) | host(${ctx.req.host}) | user_agent(${ctx.req.user_agent})',
					]
				}
			})
		}
	}
	mut controller_ctx := ur.ctx

	controllers.send_user_recomendation(mut controller_ctx, ctx.req.data) or {
		controller_ctx.log_server_action(log_models.ContractTypeServerAction{
			path:  '${@FN} | ${@FILE_LINE}'
			list_error: {
				'msg':  err.msg()
				'code': err.code().str()
			}
		})

		status_code = 400

		return ctx.json({
			'msg': err.msg()
		})
	}

	return ctx.json({
		'msg': 'Agradeço demais por sua recomendação.\nSua recomendação precisa ser confirmada no email registrado!'
	})
}

@['/confirm/:email/:uuid']
pub fn (ur &UserRecomendation) confirm(mut ctx wcontext.WsCtx, email string, uuid string) veb.Result {
	mut status_code := 200
	defer {
		lock ctx.obj {
			ctx.obj.current_path = '/api/v1/user-recomendation/confirm/:email/:uuid'
			ctx.obj.current_status_code = &status_code

			ctx.log_info({
				'path':       'RECOMENDAÇÃO USUÁRIO CONFIRMADO'
				'statusText': 'success'
				'additional': ctx_models.DataContext{
					infos: [
						'ip(${ctx.ip()}) | host(${ctx.req.host}) | user_agent(${ctx.req.user_agent})',
					]
				}
			})
		}
	}
	mut controller_ctx := ur.ctx
	footer_construct := footer.construct

	controllers.confirm_user_recomendation(email, uuid) or {
		controller_ctx.log_server_action(log_models.ContractTypeServerAction{
			path:  '${@FN} | ${@FILE_LINE}'
			list_error: {
				'msg':  err.msg()
				'code': err.code().str()
			}
		})

		status_code = 400

		return ctx.html(views.not_found(err))
	}

	ctx.log_register(
		path:     'RECOMENDAÇÃO_CONTEÚDO_USUÁRIO'
		response: {
			'confirm_recomendation': email
		}
	)

	return ctx.html($tmpl('./views/index.html'))
}
