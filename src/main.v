module main

import veb
import shareds.wcontext
import shareds.middlewares.middleware_log
import mf_core.context_service
import client.features.about as ctrl_about
import client.features.admin as ctrl_admin
import client.features.home as ctrl_home_page
import client.features.contact as ctrl_contact
import client.features.newsletter as ctrl_newsletter
import client.features.user_recomendation as ctrl_user_recomendation

pub struct Wservice {
	veb.Controller
	veb.StaticHandler
	veb.Middleware[wcontext.WsCtx]
}

fn main() {
	mut ctx := context_service.ContextService{}

	mut wservice := &Wservice{}

	mut home_page := &ctrl_home_page.HomePage{
		ctx: ctx
	}

	mut admin_page := &ctrl_admin.AdminController{
		ctx: ctx
	}

	mut about_page := &ctrl_about.AboutCrontoller{
		ctx: ctx
	}

	mut api_user_recomendation := &ctrl_user_recomendation.UserRecomendation{
		ctx: ctx
	}

	mut api_contact := &ctrl_contact.ContactController{
		ctx: ctx
	}

	mut api_newsletter := &ctrl_newsletter.NewsletterController{
		ctx: ctx
	}

	export_resources(mut wservice)!

	include_middlewares_logger(mut home_page, mut admin_page, mut api_user_recomendation, mut about_page, mut api_contact, mut api_newsletter)!

	wservice.register_controller[ctrl_home_page.HomePage, wcontext.WsCtx]('/inicio', mut
		home_page)!

	wservice.register_controller[ctrl_admin.AdminController, wcontext.WsCtx]('/admin', mut
		admin_page)!

	wservice.register_controller[ctrl_user_recomendation.UserRecomendation, wcontext.WsCtx]('/api/v1/user-recomendation', mut
		api_user_recomendation)!

	wservice.register_controller[ctrl_about.AboutCrontoller, wcontext.WsCtx]('/sobre', mut
		about_page)!

	wservice.register_controller[ctrl_contact.ContactController, wcontext.WsCtx]('/api/v1/register_contact', mut
		api_contact)!

	wservice.register_controller[ctrl_newsletter.NewsletterController, wcontext.WsCtx]('/newsletter', mut
		api_newsletter)!

	$if debug ? || debug_without_cache ? {
		println('\n--> RUNNING IN DEBUG MODE <--\n')
		veb.run[Wservice, wcontext.WsCtx](mut wservice, 3030)
	} $else {
		veb.run[Wservice, wcontext.WsCtx](mut wservice, 5058)
	}
}

fn include_middlewares_logger(mut home_page ctrl_home_page.HomePage, mut admin_page ctrl_admin.AdminController, mut api_user_recomendation ctrl_user_recomendation.UserRecomendation, mut about_page ctrl_about.AboutCrontoller, mut api_contact ctrl_contact.ContactController, mut api_newsletter ctrl_newsletter.NewsletterController) ! {
	home_page.route_use('/:...', handler: middleware_log.logger_start)
	home_page.route_use('/:...', handler: middleware_log.logger_end, after: true)

	admin_page.route_use('/:...', handler: middleware_log.logger_start)
	admin_page.route_use('/:...', handler: middleware_log.logger_end, after: true)

	api_user_recomendation.route_use('/:...', handler: middleware_log.logger_start)
	api_user_recomendation.route_use('/:...', handler: middleware_log.logger_end, after: true)
	
	about_page.route_use('/:...', handler: middleware_log.logger_start)
	about_page.route_use('/:...', handler: middleware_log.logger_end, after: true)
	
	api_contact.route_use('/:...', handler: middleware_log.logger_start)
	api_contact.route_use('/:...', handler: middleware_log.logger_end, after: true)
	
	api_newsletter.route_use('/:...', handler: middleware_log.logger_start)
	api_newsletter.route_use('/:...', handler: middleware_log.logger_end, after: true)
}

pub fn (ws &Wservice) index(mut ctx wcontext.WsCtx) veb.Result {
	return ctx.redirect('/inicio')
}

fn export_resources(mut wservice Wservice) ! {
	wservice.mount_static_folder_at('src/server/features/generate_page/view', '/assets')!

	wservice.mount_static_folder_at('src/shareds/assets', '/assets')!

	wservice.mount_static_folder_at('src/shareds/components', '/components')!
}
