module home

import veb
import shareds.logger

pub struct HomePage {
	veb.Controller
pub mut:
	log logger.ILogger
}
