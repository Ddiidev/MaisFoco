module repository

import time
import shareds.db
import server.features.user_recomendation.errors
import server.features.user_recomendation.entities

// confirmer_user_recomendation confirma uma recomendação do usuário
pub fn confirm_user_recomendation(email string, uuid string) !entities.UserRecomendation {
	mut dbase := db.ConnectionDb.new()!

	defer {
		dbase.close()
	}

	res := sql dbase.conn {
		select from entities.UserRecomendation where email == email && uuid == uuid limit 1
	}!

	if res.len == 0 {
		return errors.ErrorNotFoundRecommendation{}
	}

	sql dbase.conn {
		update entities.UserRecomendation set is_validated = true, updated_at = time.now()
		where email == email && uuid == uuid
	}!

	return res[0] or { return errors.ErrorNotFoundRecommendation{} }
}
