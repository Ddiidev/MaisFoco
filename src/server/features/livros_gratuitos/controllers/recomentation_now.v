module controllers

import shareds.logger
import server.features.livros_gratuitos.models
import server.features.livros_gratuitos.repository

pub fn get_recomendation(mut log logger.ILogger) !models.LivrosGratuitosProduct {
	data_entities := repository.get_recomendation() or {
		log.error('${@FN} | ${err.str()}')
		return err
	}

	return data_entities.to_model()
}
