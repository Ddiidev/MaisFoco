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
	request := json.decode(ContractRequest, ctx.req.data) or { return ctx.not_found() }

	if whatsapp := request.whatsapp {
		contacts.register_whatsapp(request.recaptcha_token, whatsapp) or {
			ctx.error(json.encode({
				'msg': err.msg()
			}))
			return ctx.no_content()
		}
	} else {
		ctx.error(json.encode({
			'msg': 'Campos obrigatórios não preenchidos'
		}))
	}

	return ctx.json({
		'msg': 'Número de whatsapp cadastrado com sucesso 🎉'
	})
}

@['/email'; post]
pub fn (c &ContactController) email(mut ctx wcontext.WsCtx) veb.Result {
	request := json.decode(ContractRequest, ctx.req.data) or { return ctx.not_found() }

	if email := request.email {
		contacts.register_email(request.recaptcha_token, email) or {
			ctx.error(json.encode({
				'msg': err.msg()
			}))
			return ctx.no_content()
		}
	} else {
		ctx.error(json.encode({
			'msg': 'Campos obrigatórios não preenchidos'
		}))
		return ctx.no_content()
	}

	return ctx.json({
		'msg': 'Email cadastrado com sucesso 🎉'
	})
}
