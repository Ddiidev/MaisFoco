module instant_gaming

import json
import shareds.db
import shareds.logger
import server.features.instant_gaming.models
import server.features.instant_gaming.controllers

fn testsuite_end() {
	db.clear_db_enviroment_test()
}

fn test_valid_import() ! {
	mut log := logger.Logger.new('-test-', '-test-')

	data := models.InstantGamingProduct{}

	json_str := json.encode(data)
	controllers.import(mut log, json_str)!
}
