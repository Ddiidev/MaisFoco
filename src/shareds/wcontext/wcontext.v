module wcontext

import veb

pub struct WsCtx {
	veb.Context
pub mut:
	lang string = 'en'
}

pub fn (mut ctx WsCtx) not_found() veb.Result {
	ctx.res.set_status(.not_found)
	return ctx.html($tmpl('./views/404.html'))
}
