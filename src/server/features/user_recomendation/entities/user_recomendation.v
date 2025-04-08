module entities

import time
import server.features.user_recomendation.types

@[table: 'UserRecomendations']
pub struct UserRecomendation {
pub:
	id          int    @[primary; serial]
	uuid        string @[unique]
	name        ?string
	email       string
	type        types.TypeRecomendation
	link        string
	observation ?string
	created_at  time.Time = time.now() @[sql_type: 'TIMESTAMP']
	updated_at  time.Time = time.now() @[sql_type: 'TIMESTAMP']
pub mut:
	is_validated bool @[default: 'false']
}
