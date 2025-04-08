module recomendation

import os
import veb
import time
import shareds.logger
import shareds.conf_env
import server.features.generate_page

pub fn get_recomendation_today(mut log logger.ILogger) veb.RawHtml {
	$if debug_without_cache ? {
		return generate_page.generate(mut log)
	}

	return if html := get_html_recomendation_today() {
		html
	} else {
		page := generate_page.generate(mut log)
		create_file_page(page)
		page
	}
}

fn get_html_recomendation_today() ?string {
	println('\n--> GET PAGE ON CACHE <--\n')
	env := conf_env.load_env()
	current_date := time.now().custom_format('YYYY-MM-DD')

	path_pages := env.path_pages
	if os.exists(os.join_path(path_pages, current_date, 'index.html')) {
		return os.read_file(os.join_path(path_pages, current_date, 'index.html')) or { return none }
	}

	return none
}

fn create_file_page(html string) {
	println('\n--> CREATE PAGE <--\n')
	env := conf_env.load_env()
	current_date := time.now().custom_format('YYYY-MM-DD')

	path_pages := env.path_pages

	os.mkdir_all(os.join_path(path_pages, current_date)) or {}
	os.write_file(os.join_path(path_pages, current_date, 'index.html'), html) or {
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
