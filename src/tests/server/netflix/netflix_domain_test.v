module netflix

import json
import shareds.db
import mf_core.logger
import server.features.netflix.models
import server.features.netflix.controllers

fn test_genders_import() ! {
	data := models.NetflixProduct{
		genders: 'sci-fi, action'
	}

	assert data.genders.to_list() == ['sci-fi', 'action']
}
