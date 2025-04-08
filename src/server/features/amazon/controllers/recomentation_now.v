module controllers

import shareds.logger
import server.features.amazon.models
import server.features.amazon.repository

pub fn get_recomendation(mut log logger.ILogger) ![]models.AmazonProduct {
	data_entities := repository.get_recomendation() or {
		log.error('${@FN} | ${err.str()}')
		return err
	}

	return data_entities.map(it.to_model())
}
