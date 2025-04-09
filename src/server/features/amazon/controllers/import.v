module controllers

import json
import mf_core.utils
import mf_core.logger
import mf_core.features.amazon.entities
import mf_core.features.amazon.repository

pub fn import(mut log logger.ILogger, json_str string) ! {
	mut entitie := json.decode(entities.AmazonProduct, json_str)!

	entitie.change_current_date(utils.sanitize_date_clean_time(entitie.current_date))

	repository.import(entitie) or {
		log.error('${@FN} | ${err.str()}')
		return err
	}
}
