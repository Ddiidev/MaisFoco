module user_recomendation

import veb
import shareds.logger

pub struct UserRecomendation {
	veb.Context
pub mut:
	log logger.ILogger
}
