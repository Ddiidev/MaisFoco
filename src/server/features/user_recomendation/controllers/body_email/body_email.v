module body_email

import mf_core.conf_env
import mf_core.features.user_recomendation.models

// Gera um body para enviar email de confirmação do usuário sobre a recomendação feita.
pub fn body_email_string(recommendation models.UserRecomendation) string {
	env := conf_env.load_env()

	link_confim := 'https://${env.base_domain}/api/v1/user-recomendation/confirm/${recommendation.email}/${recommendation.uuid}'
	logo := 'https://${env.base_domain}/assets/images/logo.png'

	nome := if recommendation.name == none || recommendation.name or { '' }.trim_space() == '' {
		'Sr. Anônimo 🥸'
	} else {
		recommendation.name or { '' }.str().trim_space()
	}

	tipo := recommendation.type.str()

	observacao := if recommendation.observation == none {
		''
	} else {
		recommendation.observation.trim_space()
	}

	return $tmpl('../../../../../shareds/assets/pages/confirm-recommendation.html')
}
