module views

import veb
import mf_core.conf_env
import shareds.components.footer
import mf_core.features.user_recomendation.errors

pub fn not_found(error IError) veb.RawHtml {
	env := conf_env.load_env()
	email_suporte := env.email_maisfoco_suporte

	footer_construct := footer.construct

	msg_error := if error is errors.ErrorNotFoundRecommendation {
		'Não encontramos sua recomendação'
	} else {
		'Ocorreu um erro interno, tente novamente mais tarde'
	}

	return $tmpl('./not_found.html')
}
