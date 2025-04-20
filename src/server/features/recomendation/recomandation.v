module recomendation

import os
import veb
import time
import mf_core.conf_env
import mf_core.context_service
import server.features.generate_page
import mf_core.log_observoo.models as log_models

pub fn get_recomendation_today(mut mf_ctx context_service.ContextService) veb.RawHtml {
	$if debug_without_cache ? {
		// TODO: IMPLEMENTAR LOG ""OTHER""

		return generate_page.generate(mut mf_ctx)
	}

	return if html := get_html_recomendation_today(mut mf_ctx) {
		html
	} else {
		page := generate_page.generate(mut mf_ctx)
		create_file_page(mut mf_ctx, page)
		page
	}
}

fn get_html_recomendation_today(mut mf_ctx context_service.ContextService) ?string {
	println('\n--> GET PAGE ON CACHE <--\n')
	env := conf_env.load_env()
	current_date := time.now().custom_format('YYYY-MM-DD')

	path_pages := env.path_pages
	if os.exists(os.join_path(path_pages, current_date, 'index.html')) {
		return os.read_file(os.join_path(path_pages, current_date, 'index.html')) or { return none }
	} else {
		mf_ctx.log_server_action(log_models.ContractTypeServerAction{
			method: .read
			path:   '${@FN} ${@FILE_LINE}'
			list_error:  {
				'code':    '0'
				'message': 'Não existe o arquivo ${os.join_path(path_pages, current_date,
					'index.html')}'
			}
		})
	}

	return none
}

fn create_file_page(mut mf_ctx context_service.ContextService, html string) {
	println('\n--> CREATE PAGE <--\n')
	env := conf_env.load_env()
	current_date := time.now().custom_format('YYYY-MM-DD')

	path_pages := env.path_pages

	os.mkdir_all(os.join_path(path_pages, current_date)) or {
		mf_ctx.log_server_action(log_models.ContractTypeServerAction{
			method:      .create
			path:        '${@FN} ${@FILE_LINE}'
			status_text: err.msg()
			list_error:       {
				'code':    err.code().str()
				'message': err.msg()
			}
		})
	}
	os.write_file(os.join_path(path_pages, current_date, 'index.html'), html) or {
		mf_ctx.log_server_action(log_models.ContractTypeServerAction{
			method:      .create
			path:        '${@FN} ${@FILE_LINE}'
			status_text: err.msg()
			list_error:       {
				'code':    err.code().str()
				'message': err.msg()
			}
		})
		panic('Failed to write file')
	}
}

fn force_delete_cache() {
	env := conf_env.load_env()
	println('\n--> DELETE CACHE <--\n')

	current_date := time.now().custom_format('YYYY-MM-DD')
	path_pages := env.path_pages
	os.rm(os.join_path(path_pages, current_date, 'index.html')) or {}
}
