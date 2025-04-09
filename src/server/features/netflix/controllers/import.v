module controllers

import json
import mf_core.utils
import mf_core.logger
import mf_core.features.netflix.entities
import mf_core.features.netflix.repository

pub fn import(mut log logger.ILogger, json_str string) ! {
	mut entitie := json.decode(entities.NetflixProduct, json_str)!

	entitie.change_current_date(utils.sanitize_date_clean_time(entitie.current_date))

	repository.import(entitie) or {
		log.error('${@FN} | ${err.str()}')
		return err
	}
}
