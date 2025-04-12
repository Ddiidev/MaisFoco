module home

import veb
import time
import shareds.wcontext
import server.features.recomendation
import shareds.components.menu_floating
import shareds.components.register_contact

const holidays = [
	6,
	7,
]

fn (home &HomePage) index(mut ctx wcontext.WsCtx) veb.Result {
	construct_menu_floating := menu_floating.construct
	construct_register_contract := register_contact.construct

	mut log := home.log

	if time.now().day_of_week() in holidays {
		return $veb.html('./views/weekend.html')
	} else {
		return ctx.html(recomendation.get_recomendation_today(mut log))
	}
}
