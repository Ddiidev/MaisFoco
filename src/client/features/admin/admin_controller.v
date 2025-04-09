module admin

import veb
import mf_core.logger

pub struct AdminController {
	veb.Controller
pub mut:
	log logger.ILogger
}
