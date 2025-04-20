module contact

import veb
import shareds.wcontext
import mf_core.context_service

pub struct ContactController {
	veb.Context
	veb.Middleware[wcontext.WsCtx]
pub:
	ctx context_service.ContextService
}
