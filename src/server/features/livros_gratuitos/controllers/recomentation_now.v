module controllers

import mf_core.context_service
import mf_core.features.livros_gratuitos.models
import mf_core.log_observoo.models as log_models
import mf_core.features.livros_gratuitos.repository

pub fn get_recomendation(mut mf_ctx context_service.ContextService) !models.LivrosGratuitosProduct {
	data_entities := repository.get_recomendation() or {
		mf_ctx.log_server_action(log_models.ContractTypeServerAction{
			method:      .read
			path:        '${@FN} ${@FILE_LINE}'
			status_text: err.msg()
			list_error:       {
				'code':    err.code().str()
				'message': err.msg()
			}
		})
		return err
	}

	return data_entities.to_model()
}
