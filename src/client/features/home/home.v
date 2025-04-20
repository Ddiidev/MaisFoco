module home

import veb
import time
import shareds.wcontext
import server.features.recomendation
import shareds.components.menu_floating
import shareds.components.register_contact
import mf_core.context_service.models as ctx_models

const holidays = [
	6, // sábado
	7, // domingo
]

fn (home &HomePage) index(mut ctx wcontext.WsCtx) veb.Result {
	mut custom_response := map[string]string{}
	defer {
		lock ctx.obj {
			ctx.obj.current_path = '/inicio'
			ctx.obj.custom_response = &custom_response
			ctx.obj.current_status_code = 200

			ctx.log_info({
				'path':       'PÁGINA /inicio'
				'statusText': 'success'
				'additional': ctx_models.DataContext{
					infos: [
						'ip(${ctx.ip()}) | host(${ctx.req.host}) | user_agent(${ctx.req.user_agent})',
					]
				}
			})
		}
	}

	mut controller_ctx := home.ctx
	construct_menu_floating := menu_floating.construct
	construct_register_contract := register_contact.construct

	if time.now().day_of_week() in holidays {
		custom_response['holyday'] = 'true'
		return ctx.html($tmpl('./views/weekend.html'))
	} else {
		return ctx.html(recomendation.get_recomendation_today(mut controller_ctx))
	}
}
