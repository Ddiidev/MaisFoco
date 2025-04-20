module middleware_log

import time
import shareds.wcontext
import mf_core.log_observoo.models as log_models

pub fn logger_start(mut ctx wcontext.WsCtx) bool {
	lock ctx.obj {
		ctx.obj.start_req_time = time.now()
	}
	return true
}

pub fn logger_end(mut ctx wcontext.WsCtx) bool {
	lock ctx.obj {
		current_time := time.now()
		ctx.obj.duration = current_time - ctx.obj.start_req_time

		ctx.log_api(log_models.ContractTypeApi{
			path: ctx.obj.current_path
			method: ctx.obj.current_method
			response: ctx.obj.custom_response
			status_code: ctx.obj.current_status_code
			duration: '${ctx.obj.duration.seconds():.2f}'
		})
	}
	return true
}