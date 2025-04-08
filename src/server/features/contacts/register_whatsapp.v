module contacts

import recaptcha
import shareds.utils
import shareds.conf_env
import server.features.contacts.entities
import server.features.contacts.repository

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
