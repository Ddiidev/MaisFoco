module amazon

import time
import json
import shareds.db
import mf_core.utils
import mf_core.logger
import server.features.amazon.models
import server.features.amazon.controllers

fn testsuite_end() {
	db.clear_db_enviroment_test()
}

fn test_recomendation_now() ! {
	mut log := logger.Logger.new('-test-', '-test-')

	data := models.AmazonProduct{
		current_date: time.now()
	}

	json_str := json.encode(data)
	controllers.import(mut log, json_str)!

	recomendation := controllers.get_recomendation(mut log)!

	assert recomendation.len == 1
	assert recomendation[0].current_date == utils.sanitize_date_clean_time(data.current_date)

	mut conn := db.ConnectionDb.new()!
	conn.execute('delete from AmazonProducts')!
	conn.close()
}

fn test_empty_recomendation() ! {
	mut log := logger.Logger.new('-test-', '-test-')

	data := models.AmazonProduct{
		current_date: time.now().add_days(1)
	}

	json_str := json.encode(data)
	controllers.import(mut log, json_str)!

	recomendation := controllers.get_recomendation(mut log)!

	assert recomendation.len == 0
}
