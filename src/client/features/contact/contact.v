module contact

import veb
import json
import shareds.wcontext
import server.features.contacts

struct ContractRequest {
	recaptcha_token string @[json: 'recaptchaToken']
	whatsapp        ?string
	email           ?string
}

@['/whatsapp'; post]
pub fn (c &ContactController) whatsapp(mut ctx wcontext.WsCtx) veb.Result {
	mut status_code := 200
	mut custom_response := map[string]string{}
	defer {
		lock ctx.obj {
			ctx.obj.current_path = '/api/v1/register_contact/whatsapp'
			ctx.obj.current_status_code = &status_code
			ctx.obj.custom_response = &custom_response // Added custom_response
			ctx.obj.current_method = 'POST'
		}
	}
	mut controller_ctx := c.ctx
	request := json.decode(ContractRequest, ctx.req.data) or { return ctx.not_found() }

	if whatsapp := request.whatsapp {
		contacts.register_whatsapp(mut controller_ctx, request.recaptcha_token, whatsapp) or {
			ctx.error(json.encode({
				'msg': err.msg()
			}))

			status_code = 400
			custom_response['msg'] = err.msg()
			return ctx.no_content()
		}
	} else {
		status_code = 400
		custom_response['msg'] = 'Campos obrigatórios não preenchidos'
		ctx.error(json.encode({
			'msg': 'Campos obrigatórios não preenchidos'
		}))
		return ctx.no_content()
	}

	ctx.log_register(
		path:    'REGISTRO_CONTATO_WHATSAPP'
		response: {
			'novo_usuario': request.whatsapp or { '' }
		}
	)

	return ctx.json({
		'msg': 'Número de whatsapp cadastrado com sucesso 🎉'
	})
}

@['/email'; post]
pub fn (c &ContactController) email(mut ctx wcontext.WsCtx) veb.Result {
	mut status_code := 200
	mut custom_response := map[string]string{}

	defer {
		lock ctx.obj {
			ctx.obj.current_path = '/api/v1/register_contact/email'
			ctx.obj.current_status_code = &status_code
			ctx.obj.custom_response = &custom_response
			ctx.obj.current_method = 'POST'
		}
	}
	mut controller_ctx := c.ctx
	request := json.decode(ContractRequest, ctx.req.data) or { return ctx.not_found() }

	if email := request.email {
		contacts.register_email(mut controller_ctx, request.recaptcha_token, email) or {
			ctx.error(json.encode({
				'msg': err.msg()
			}))

			status_code = 400
			custom_response['msg'] = err.msg()
			return ctx.no_content()
		}
	} else {
		ctx.error(json.encode({
			'msg': 'Campos obrigatórios não preenchidos'
		}))
		status_code = 400
		custom_response['msg'] = err.msg()
		
		return ctx.no_content()
	}

	ctx.log_register(
		path:    'REGISTRO_CONTATO_EMAIL'
		response: {
			'novo_usuario': request.email or { '' }
		}
	)

	return ctx.json({
		'msg': 'Email cadastrado com sucesso 🎉'
	})
}
