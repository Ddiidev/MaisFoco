module recomendation

import veb

pub fn construct() veb.RawHtml {
	env_dev := $if debug_without_cache ? {
		true
	} $else {
		false
	}

	return $tmpl('./recomendation_form.html')
}
