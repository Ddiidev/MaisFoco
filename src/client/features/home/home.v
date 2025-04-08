module home

import veb
import shareds.wcontext
import server.features.recomendation

fn (home &HomePage) index(mut ctx wcontext.WsCtx) veb.Result {
	mut log := home.log
	return ctx.html(recomendation.get_recomendation_today(mut log))
}
