module main

import veb
import shareds.logger
import shareds.wcontext
import client.features.about as ctrl_about
import client.features.admin as ctrl_admin
import client.features.home as ctrl_home_page
import client.features.contact as ctrl_contact
import client.features.user_recomendation as ctrl_user_recomendation
import client.features.newsletter as ctrl_newsletter

pub struct Wservice {
	veb.Controller
	veb.StaticHandler
}

fn main() {
	mut log := logger.Logger.new('./logs', 'log')

	mut wservice := &Wservice{}

	mut home_page := &ctrl_home_page.HomePage{
		log: log
	}

	mut admin_page := &ctrl_admin.AdminController{
		log: log
	}

	mut about_page := &ctrl_about.AboutCrontoller{
		log: log
	}

	mut api_user_recomendation := &ctrl_user_recomendation.UserRecomendation{
		log: log
	}

	mut api_contact := &ctrl_contact.ContactController{
		log: log
	}

	mut api_newsletter := &ctrl_newsletter.NewsletterController{
		log: log
	}

	export_resources(mut wservice)!

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

pub fn (ws &Wservice) index(mut ctx wcontext.WsCtx) veb.Result {
	return ctx.redirect('/inicio')
}

fn export_resources(mut wservice Wservice) ! {
	wservice.mount_static_folder_at('src/server/features/generate_page/view', '/assets')!

	wservice.mount_static_folder_at('src/shareds/assets', '/assets')!

	wservice.mount_static_folder_at('src/shareds/components', '/components')!
}
