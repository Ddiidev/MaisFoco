module footer

import veb
import time

pub fn construct() veb.RawHtml {
	year := time.now().year

	return $tmpl('./footer.html')
}
