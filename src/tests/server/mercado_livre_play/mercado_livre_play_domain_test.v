module mercado_livre_play

import json
import shareds.db
import shareds.logger
import server.features.mercado_livre_play.models
import server.features.mercado_livre_play.controllers

fn test_genders_import() ! {
	data := models.MercadoLivrePlayProduct{
		genders: 'sci-fi, classic'
	}

	assert data.genders.to_list() == ['sci-fi', 'classic']
}
