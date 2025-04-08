module user_recomendation

import veb
import shareds.wcontext
import shareds.components.footer
import client.features.user_recomendation.views
import server.features.user_recomendation.controllers

@['/'; post]
pub fn (ur &UserRecomendation) send_confirmation(mut ctx wcontext.WsCtx) veb.Result {
	controllers.send_user_recomendation(ctx.req.data) or {
		return ctx.json({
			'msg': err.msg()
		})
	}

	return ctx.json({
		'msg': 'Agradeço demais por sua recomendação.\nSua recomendação precisa ser confirmada no email registrado!'
	})
}

@['/confirm/:email/:uuid']
pub fn (ur &UserRecomendation) confirm(mut ctx wcontext.WsCtx, email string, uuid string) veb.Result {
	footer_construct := footer.construct

	controllers.confirm_user_recomendation(email, uuid) or { return ctx.html(views.not_found(err)) }

	return ctx.html($tmpl('./views/index.html'))
}
