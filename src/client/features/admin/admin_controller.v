module admin

import veb
import shareds.wcontext
import mf_core.context_service

pub struct AdminController {
	veb.Controller
	veb.Middleware[wcontext.WsCtx]
pub mut:
	ctx context_service.ContextService
}
