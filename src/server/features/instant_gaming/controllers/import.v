module controllers

import json
import mf_core.utils
import mf_core.context_service
import mf_core.features.instant_gaming.entities
import mf_core.log_observoo.models as log_models
import mf_core.features.instant_gaming.repository

pub fn import(mut mf_ctx context_service.ContextService, json_str string) ! {
	mf_ctx.add_callstack(@FN)

	mut entitie := json.decode(entities.InstantGamingProduct, json_str)!

	entitie.change_current_date(utils.sanitize_date_clean_time(entitie.current_date))

	repository.import(entitie) or {
		mf_ctx.log_server_action(log_models.ContractTypeServerAction{
			method:      .create
			path:        '${@FN} ${@FILE_LINE}'
			status_text: err.msg()
			list_error:       {
				'code':    err.code().str()
				'message': err.msg()
			}
		})
		return err
	}

	mf_ctx.log_server_action(log_models.ContractTypeServerAction{
		method:      .create
		path:        '${@FN} ${@FILE_LINE}'
		status_text: 'success'
	})
}
