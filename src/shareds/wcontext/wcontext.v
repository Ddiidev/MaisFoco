module wcontext

import veb
import time
import mf_core.context_service

pub struct WsCtx {
	veb.Context
	context_service.ContextService
pub mut:
	obj  shared ObjectShared
	lang string = 'en'
}

pub struct ObjectShared {
pub mut:
	start_req_time      time.Time
	duration            time.Duration
	current_path        string
	current_method      string = 'GET'
	current_status_code int    = 200
	custom_response     map[string]string
}

pub fn (mut ctx WsCtx) not_found() veb.Result {
	ctx.res.set_status(.not_found)
	return ctx.html($tmpl('./views/404.html'))
}
