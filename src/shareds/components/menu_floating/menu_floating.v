module menu_floating

import veb
import shareds.components.recomendation

pub fn construct() veb.RawHtml {
	comp_recomendation_form := recomendation.construct

	return $tmpl('./index.html')
}
