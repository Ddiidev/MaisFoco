module generate_page

import os
import time
import json
import shareds.db
import mf_core.logger
import server.features.generate_page as generate_page_module
import server.features.amazon.models as models_amazon
import server.features.amazon.controllers as control_amazon
import server.features.netflix.controllers as control_netflix
import server.features.netflix.models as models_netflix
import server.features.instant_gaming.controllers as control_instant_gaming
import server.features.instant_gaming.models as models_instant_gaming
import server.features.mercado_livre_play.controllers as control_mercado_livre_play
import server.features.mercado_livre_play.models as models_mercado_livre_play
import server.features.livros_gratuitos.controllers as control_livros_gratuitos
import server.features.livros_gratuitos.models as models_livros_gratuitos

fn testsuite_end() {
	db.clear_db_enviroment_test()
}

fn test_generate_page() ! {
	mut log := logger.Logger.new('-test-', '-test-')

	import_amazom(mut log)!
	import_netflix(mut log)!
	import_instant_gaming(mut log)!
	import_mercado_livre_play(mut log)!
	import_livros_gratuitos(mut log)!

	page := generate_page_module.generate(mut log)

	os.write_file('./page.html', page)!
	assert page.len > 100
}

fn import_amazom(mut log logger.ILogger) ! {
	model_amazom := models_amazon.AmazonProduct{
		current_date: time.now()
		link:         'https://www.amazon.com.br'
	}

	control_amazon.import(mut log, json.encode(model_amazom))!
}

fn import_netflix(mut log logger.ILogger) ! {
	model_netflix := models_netflix.NetflixProduct{
		current_date: time.now()
		link:         'https://www.netflix.com'
	}

	control_netflix.import(mut log, json.encode(model_netflix))!
}

fn import_instant_gaming(mut log logger.ILogger) ! {
	model_instant_gaming := models_instant_gaming.InstantGamingProduct{
		current_date: time.now()
		link:         'https://www.instantgaming.com'
	}

	control_instant_gaming.import(mut log, json.encode(model_instant_gaming))!
}

fn import_mercado_livre_play(mut log logger.ILogger) ! {
	model_mercado_livre_play := models_mercado_livre_play.MercadoLivrePlayProduct{
		current_date: time.now()
		link:         'https://www.mercadolivre.com'
	}

	control_mercado_livre_play.import(mut log, json.encode(model_mercado_livre_play))!
}

fn import_livros_gratuitos(mut log logger.ILogger) ! {
	model_livros_gratuitos := models_livros_gratuitos.LivrosGratuitosProduct{
		current_date: time.now()
		link:         'https://www.livrosgratuitos.com'
	}

	control_livros_gratuitos.import(mut log, json.encode(model_livros_gratuitos))!
}
