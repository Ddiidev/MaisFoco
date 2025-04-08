module about

import veb
import shareds.wcontext
import shareds.components.menu_floating

pub fn (a &AboutCrontoller) index(mut ctx wcontext.WsCtx) veb.Result {
	construct_menu_floating := menu_floating.construct
	return $veb.html('./views/index.html')
}
