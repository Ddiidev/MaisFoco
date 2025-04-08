module repository

import shareds.db
import server.features.livros_gratuitos.entities

pub fn import(entitie entities.LivrosGratuitosProduct) ! {
	mut dbase := db.ConnectionDb.new()!
	defer {
		dbase.close()
	}

	sql dbase.conn {
		insert entitie into entities.LivrosGratuitosProduct
	}!
}
