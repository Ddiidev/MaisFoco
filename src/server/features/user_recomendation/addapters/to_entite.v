module addapters

import server.features.user_recomendation.models
import server.features.user_recomendation.entities

pub fn adapt_to_entitie(user_recomendation models.UserRecomendation) entities.UserRecomendation {
	return entities.UserRecomendation{
		id:           user_recomendation.id
		email:        user_recomendation.email
		link:         user_recomendation.link
		name:         user_recomendation.name
		type:         user_recomendation.type
		observation:  user_recomendation.observation
		uuid:         user_recomendation.uuid
		is_validated: false
	}
}
