module models

import recaptcha
import shareds.utils
import shareds.conf_env
import server.features.user_recomendation.types

pub struct UserRecomendation {
pub:
	id              int
	uuid            string
	name            ?string
	email           string
	type            types.TypeRecomendation
	link            string
	observation     ?string
	recaptcha_token string @[json: 'recaptchaToken']
}

pub fn (ur UserRecomendation) validate() ! {
	valid_name(ur.name)!
	valid_email(ur.email)!
	valid_observation(ur.observation)!
	valid_token_recaptcha(ur.recaptcha_token)!
}

fn valid_token_recaptcha(token string) ! {
	$if debug_without_cache ? {
		return
	}

	env := conf_env.load_env()
	if token.len == 0 {
		return error('O token do recaptcha é obrigatório')
	}

	captcha := recaptcha.new(secret_key: env.recaptcha_secret, token: token) or {
		return error('O token do recaptcha é inválido')
	}

	if !captcha.is_valid() {
		return error('O token do recaptcha é inválido')
	}
}

fn valid_name(name ?string) ! {
	if name == none {
		return
	}
	name_ := name or { '' }.trim_space()

	if name_.split(' ').len > 2 {
		return error('O nome deve ter no máximo 2 palavras')
	}

	if name_.len > 80 {
		return error('O nome deve ter no máximo 80 caracteres')
	}
}

fn valid_email(email string) ! {
	if !utils.validating_email(email) {
		return error('Email inválido "${email}"')
	}
}

fn valid_observation(observation ?string) ! {
	max_chars := 150
	if observation or { '' }.len > max_chars {
		return error('A ovbservação deve ter no máximo ${max_chars} caracteres')
	}
}
