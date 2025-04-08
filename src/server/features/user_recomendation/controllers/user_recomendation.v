module controllers

import json
import rand
import shareds.utils
import server.features.user_recomendation.models
import server.features.user_recomendation.entities
import server.features.user_recomendation.addapters
import server.features.user_recomendation.repository

pub fn send_user_recomendation(recomendation_json string) ! {
	recomendation_model := json.decode(models.UserRecomendation, recomendation_json)!

	recomendation_model.validate()!

	mut recomendation_entitie := addapters.adapt_to_entitie(recomendation_model)

	recomendation_entitie = entities.UserRecomendation{
		...recomendation_entitie
		uuid: rand.uuid_v4()
	}

	repository.insert_new_recomendation_pending_validation(mut recomendation_entitie)!

	send_confirm_email_user_recomendation(models.UserRecomendation{
		...recomendation_model
		uuid: recomendation_entitie.uuid
	})!
}

pub fn confirm_user_recomendation(user_email string, recomendation_uuid string) !models.UserRecomendation {
	if !utils.is_valid_uuid(recomendation_uuid) {
		return error('Recomendação não é válida')
	}

	if !utils.validating_email(user_email) {
		return error('Este email não é válido')
	}

	return addapters.adapt_to_model(repository.confirm_user_recomendation(user_email,
		recomendation_uuid)!)
}
