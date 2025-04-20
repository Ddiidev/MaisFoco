module newsletter

import veb
import shareds.wcontext
import mf_core.context_service

pub struct NewsletterController {
	veb.Controller
	veb.Middleware[wcontext.WsCtx]
pub:
	ctx context_service.ContextService
}
