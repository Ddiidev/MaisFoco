module controllers

import json
import shareds.utils
import shareds.logger
import server.features.instant_gaming.entities
import server.features.instant_gaming.repository

pub fn import(mut log logger.ILogger, json_str string) ! {
	mut entitie := json.decode(entities.InstantGamingProduct, json_str)!

	entitie.change_current_date(utils.sanitize_date_clean_time(entitie.current_date))

	repository.import(entitie) or {
		log.error('${@FN} | ${err.str()}')
		return err
	}
}
