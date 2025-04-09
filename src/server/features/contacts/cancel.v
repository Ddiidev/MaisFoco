module contacts

import json
import rand
import net.http
import mf_core.utils
import mf_core.conf_env
import mf_core.handle_email.service as email
import mf_core.features.contacts.repository

const endpoint = 'layer-maisfoco/confirm-cancel-whatsapp'

// start_cancel envia mensagem para confirmar cancelamento de contato
pub fn start_cancel(contact string) ! {
	env := conf_env.load_env()
	uuid_confirmation_cancel := rand.uuid_v4()
	link_cancelation := 'https://${env.base_domain}/newsletter/cancel/confirm/${uuid_confirmation_cancel}'

	if utils.validating_email(contact) {
		hemail := email.get()
		hemail.send(contact, 'Mais foco 🌱: Confirmar cancelamento', $tmpl('./cancel_email_body.html'))!

		repository.insert_confirmation_cancel(contact, uuid_confirmation_cancel)!
	} else if utils.validate_phone_number(contact) {
		url := '${env.job_send_recomendation_url}/${endpoint}'

		repository.insert_confirmation_cancel(contact, uuid_confirmation_cancel)!

		http.post_json(url, json.encode({
			'contact': contact
			'link':    link_cancelation
		}))!
	} else {
		return error('${contact} Não é um email ou número de telefone válido')
	}
}

// confirm_cancel confirma cancelamento de contato
pub fn confirm_cancel(uuid string) ! {
	if contact := repository.get_confirm_cancel(uuid) {
		if contact.email != none {
			repository.delete_email(contact.email)!
		} else if contact.whatsapp != none {
			repository.delete_whatsapp(contact.whatsapp)!
		}
	}
}
