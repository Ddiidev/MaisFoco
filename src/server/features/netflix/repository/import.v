module repository

import shareds.db
import server.features.netflix.entities

pub fn import(entitie entities.NetflixProduct) ! {
	mut dbase := db.ConnectionDb.new()!
	defer {
		dbase.close()
	}

	sql dbase.conn {
		insert entitie into entities.NetflixProduct
	}!
}
