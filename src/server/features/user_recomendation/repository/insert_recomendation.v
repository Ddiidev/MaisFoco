module repository

import shareds.db
import server.features.user_recomendation.entities

// Insere uma nova recomendação pendente de validação.
pub fn insert_new_recomendation_pending_validation(mut entitie entities.UserRecomendation) ! {
	mut dbase := db.ConnectionDb.new()!

	defer {
		dbase.close()
	}

	// TODO: Precisa abrir issue, para não ficar escroto desse jeito.
	entitie_ := entitie

	id := sql dbase.conn {
		insert entitie_ into entities.UserRecomendation
	} or { 0 }

	entitie = sql dbase.conn {
		select from entities.UserRecomendation where id == id
	}![0] or { return error('Falhou ao registrar a recomendação.') }
}
