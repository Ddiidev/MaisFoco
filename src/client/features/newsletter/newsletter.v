module newsletter

import veb
import mf_core.utils
import shareds.wcontext
import server.features.contacts

@['/cancel/:contact']
fn (nl &NewsletterController) cancel(mut ctx wcontext.WsCtx, contact string) veb.Result {
	mut msg_error := ''
	mut log := nl.log

	log.info('${@FN} || Iniciando cancelamento')

	contact_mode := if utils.validate_phone_number(contact) {
		'WhatsApp'
	} else if utils.validating_email(contact) {
		'Email'
	} else {
		msg_error = 'Número ou email inválido'
		'---'
	}

	log.info('${@FN} || Modo de contato: ${contact_mode}')

	contacts.start_cancel(contact) or {
		msg_error = 'Erro ao tentar enviar confirmação de cancelamento, favor entrar em contato via email (contato@maisfoco.life).'
		log.error('${@FN} || ${err.msg()}')
	}

	log.info('${@FN} || MsgErrror: ${msg_error}')

	return $veb.html('./views/start_cancel.html')
}

@['/cancel/confirm/:uuid']
fn (nl &NewsletterController) confirm_cancel(mut ctx wcontext.WsCtx, uuid string) veb.Result {
	mut log := nl.log
	log.info('${@FN} || Confirmando cancelamento')

	contacts.confirm_cancel(uuid) or { log.error('${@FN} || ${err.msg()}') }

	log.info('${@FN} || Cancelamento confirmado com sucesso')

	return $veb.html('./views/confirm_cancel.html')
}
