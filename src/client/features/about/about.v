module about

import veb
import shareds.wcontext
import shareds.components.menu_floating
import mf_core.context_service.models as ctx_models

@['/']
pub fn (a &AboutCrontoller) index(mut ctx wcontext.WsCtx) veb.Result {
	defer {
		lock ctx.obj {
			ctx.obj.current_path = '/sobre'
			ctx.obj.current_status_code = 200
			
			ctx.log_info({
				'path': 'PÁGINA /sobre'
				'statusText': 'success'
				'additional': ctx_models.DataContext{
					infos: [
						'ip(${ctx.ip()}) | host(${ctx.req.host}) | user_agent(${ctx.req.user_agent})'
					]
				}
			})
		}
	}

	construct_menu_floating := menu_floating.construct
	
	return ctx.html($tmpl('./views/index.html'))
}
