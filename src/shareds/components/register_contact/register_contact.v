module register_contact

import veb

pub fn construct() veb.RawHtml {
	return $tmpl('./index.html')
}
