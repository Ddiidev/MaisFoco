module mercado_livre_play

import json
import shareds.db
import mf_core.logger
import server.features.mercado_livre_play.models
import server.features.mercado_livre_play.controllers

fn testsuite_end() {
	db.clear_db_enviroment_test()
}

fn test_valid_import() ! {
	mut log := logger.Logger.new('-test-', '-test-')

	data := models.MercadoLivrePlayProduct{}

	json_str := json.encode(data)
	controllers.import(mut log, json_str)!
}
