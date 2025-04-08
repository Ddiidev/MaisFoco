module livros_gratuitos

import json
import shareds.db
import shareds.logger
import server.features.livros_gratuitos.models
import server.features.livros_gratuitos.controllers

fn testsuite_end() {
	db.clear_db_enviroment_test()
}

fn test_valid_import() ! {
	mut log := logger.Logger.new('-test-', '-test-')

	data := models.LivrosGratuitosProduct{}

	json_str := json.encode(data)
	controllers.import(mut log, json_str)!
}
