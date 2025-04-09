module user_recomendation

import veb
import mf_core.logger

pub struct UserRecomendation {
	veb.Context
pub mut:
	log logger.ILogger
}
