module newsletter

import veb
import mf_core.logger

pub struct NewsletterController {
	veb.Controller
pub mut:
	log logger.ILogger
}
