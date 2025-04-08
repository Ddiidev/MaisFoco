module livros_gratuitos

import json
import shareds.db
import shareds.logger
import server.features.livros_gratuitos.models
import server.features.livros_gratuitos.controllers

fn test_genders_import() ! {
	data := models.LivrosGratuitosProduct{
		genders: 'classic, action'
	}

	assert data.genders.to_list() == ['classic', 'action']
}
