module instant_gaming

import time
import json
import shareds.db
import shareds.utils
import shareds.logger
import server.features.instant_gaming.models
import server.features.instant_gaming.controllers

fn testsuite_end() {
	db.clear_db_enviroment_test()
}

fn test_recomendation_now() ! {
	mut log := logger.Logger.new('-test-', '-test-')

	data := models.InstantGamingProduct{
		current_date: time.now()
	}

	json_str := json.encode(data)
	controllers.import(mut log, json_str)!

	recomendation := controllers.get_recomendation(mut log)!

	assert recomendation.current_date == utils.sanitize_date_clean_time(time.now())

	mut conn := db.ConnectionDb.new()!
	conn.execute('delete from InstantGamingProducts')!
	conn.close()
}

fn test_empty_recomendation() ! {
	mut log := logger.Logger.new('-test-', '-test-')

	data := models.InstantGamingProduct{
		current_date: time.now().add_days(1)
	}

	json_str := json.encode(data)
	controllers.import(mut log, json_str)!

	recomendation := controllers.get_recomendation(mut log)!
}
