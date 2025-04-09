module controllers

import json
import mf_core.utils
import mf_core.logger
import mf_core.features.livros_gratuitos.entities
import mf_core.features.livros_gratuitos.repository

pub fn import(mut log logger.ILogger, json_str string) ! {
	mut entitie := json.decode(entities.LivrosGratuitosProduct, json_str)!

	entitie.change_current_date(utils.sanitize_date_clean_time(entitie.current_date))

	repository.import(entitie) or {
		log.error('${@FN} | ${err.str()}')
		return err
	}
}
