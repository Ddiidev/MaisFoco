module admin

import veb
import shareds.logger

pub struct AdminController {
	veb.Controller
pub mut:
	log logger.ILogger
}
