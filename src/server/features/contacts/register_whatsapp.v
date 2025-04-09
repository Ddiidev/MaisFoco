module contacts

import recaptcha
import mf_core.utils
import mf_core.conf_env
import mf_core.features.contacts.entities
import mf_core.features.contacts.repository

pub fn register_whatsapp(recaptcha_token string, whatsapp string) ! {
	env := conf_env.load_env()
	response := recaptcha.new(token: recaptcha_token, secret_key: env.recaptcha_secret)!

	if response.is_valid() {
		if !utils.validate_phone_number(whatsapp) {
			return error('Número de whatsapp inválido')
		}

		repository.insert(entities.Contact{
			whatsapp: whatsapp
		})!
	} else {
		return error('Ocorreu uma falha ao autenticar o recaptcha')
	}
}
