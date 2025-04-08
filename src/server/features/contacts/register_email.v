module contacts

import recaptcha
import shareds.utils
import shareds.conf_env
import server.features.contacts.entities
import server.features.contacts.repository

pub fn register_email(recaptcha_token string, email string) ! {
	env := conf_env.load_env()
	response := recaptcha.new(token: recaptcha_token, secret_key: env.recaptcha_secret)!

	if response.is_valid() {
		if !utils.validating_email(email) {
			return error('O email informado é inválido')
		}

		repository.insert(entities.Contact{
			email: email
		})!
	} else {
		return error('Ocorreu uma falha ao autenticar o recaptcha')
	}
}
