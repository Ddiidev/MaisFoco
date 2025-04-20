module newsletter

import veb
import mf_core.utils
import shareds.wcontext
import server.features.contacts
import mf_core.log_observoo.models as log_models

@['/cancel/:contact']
fn (nl &NewsletterController) cancel(mut ctx wcontext.WsCtx, contact string) veb.Result {
	mut status_code := 200
	mut custom_response := map[string]string{}
	defer {
		lock ctx.obj {
			ctx.obj.current_path = '/newsletter/cancel/:contact'
			ctx.obj.current_status_code = &status_code
			ctx.obj.custom_response = &custom_response
		}
	}

	contact_mode := if utils.validate_phone_number(contact) {
		'WhatsApp'
	} else if utils.validating_email(contact) {
		'Email'
	} else {
		status_code = 401
		custom_response['msg'] = 'Número ou email inválido'
		'---'
	}

	contacts.start_cancel(mut ctx.ContextService, contact) or {
		status_code = 401
		custom_response['msg'] = 'Erro ao tentar enviar confirmação de cancelamento, favor entrar em contato via email (contato@maisfoco.life).' // Added custom_response assignment
		ctx.log_server_action(log_models.ContractTypeServerAction{
			path:       '${@FN} | ${@FILE_LINE}'
			list_error: {
				'msg':  custom_response['msg']
				'code': '401'
			}
		})
		return ctx.no_content()
	}

	ctx.log_register(
		path:     'NEWSLETTER_INIALIZA_CANCELAMENTO'
		response: {
			'modo_contato': contact_mode
			'cancelar_registro': contact
		}
	)

	return ctx.html($tmpl('./views/confirm_cancel.html'))
}

@['/cancel/confirm/:uuid']
fn (nl &NewsletterController) confirm_cancel(mut ctx wcontext.WsCtx, uuid string) veb.Result {
	mut status_code := 200
	mut custom_response := map[string]string{}
	defer {
		lock ctx.obj {
			ctx.obj.current_path = '/newsletter/cancel/confirm/:uuid'
			ctx.obj.current_status_code = &status_code
			ctx.obj.custom_response = &custom_response
		}
	}

	contacts.confirm_cancel(uuid) or {
		status_code = 401
		custom_response['msg'] = err.msg()
		ctx.log_server_action(log_models.ContractTypeServerAction{
			path:       '${@FN} | ${@FILE_LINE}'
			list_error: {
				'msg':  err.msg()
				'code': err.code().str()
			}
		})
		return ctx.no_content()
	}

	ctx.log_register(
		path:     'NEWSLETTER_CONFIRMA_CANCELAMENTO'
		response: {
			'cancel_registration': uuid
		}
	)

	return ctx.html($tmpl('./views/confirm_cancel.html'))
}
