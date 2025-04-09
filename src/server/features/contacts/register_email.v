module contacts

import recaptcha
import mf_core.utils
import mf_core.conf_env
import mf_core.features.contacts.entities
import mf_core.features.contacts.repository

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
