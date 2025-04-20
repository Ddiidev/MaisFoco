module home

import veb
import shareds.wcontext
import mf_core.context_service

pub struct HomePage {
	veb.Controller
	veb.Context
	veb.Middleware[wcontext.WsCtx]
pub mut:
	ctx context_service.ContextService
}