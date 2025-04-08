module newsletter

import veb
import shareds.logger

pub struct NewsletterController {
	veb.Controller
pub mut:
	log logger.ILogger
}
