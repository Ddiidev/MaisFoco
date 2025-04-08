module repository

import shareds.db
import server.features.mercado_livre_play.entities

pub fn import(entitie entities.MercadoLivrePlayProduct) ! {
	mut dbase := db.ConnectionDb.new()!
	defer {
		dbase.close()
	}

	sql dbase.conn {
		insert entitie into entities.MercadoLivrePlayProduct
	}!
}
