module controllers

import json
import rand
import mf_core.utils
import mf_core.context_service
import mf_core.log_observoo.models as log_models
import mf_core.features.user_recomendation.models
import mf_core.features.user_recomendation.addapters
import mf_core.features.user_recomendation.repository

// send_user_recomendation Enviar uma nova recomendação do usuário
pub fn send_user_recomendation(mut mf_ctx context_service.ContextService, recomendation_json string) ! {
	recomendation_model := models.UserRecomendation{
		...json.decode(models.UserRecomendation, recomendation_json) or {
			mf_ctx.log_server_action(log_models.ContractTypeServerAction{
				method:     .read
				path:       '${@FN} ${@FILE_LINE}'
				list_error: {
					'code':    err.code().str()
					'message': err.msg()
				}
			})
			return err
		}
		uuid: rand.uuid_v4().str()
	}

	recomendation_model.validate() or {
		mf_ctx.log_register(log_models.ContractTypeRegister{
			path:       '${@FN} ${@FILE_LINE}'
			list_error: {
				'fail_validation': 'true'
				'code':    err.code().str()
				'message': err.msg()
			}
		})
		return err
	}

	mut recomendation_entitie := addapters.adapt_to_entitie(recomendation_model)

	repository.insert_new_recomendation_pending_validation(mut recomendation_entitie) or {
		mf_ctx.log_register(log_models.ContractTypeRegister{
			path:       '${@FN} ${@FILE_LINE}'
			list_error: {
				'code':    err.code().str()
				'message': err.msg()
				'data':    json.encode(recomendation_entitie)
			}
		})
		return err
	}

	send_confirm_email_user_recomendation(models.UserRecomendation{
		...recomendation_model
		uuid: recomendation_entitie.uuid
	}) or {
		mf_ctx.log_register(log_models.ContractTypeRegister{
			path:       '${@FN} ${@FILE_LINE}'
			list_error: {
				'code':    err.code().str()
				'message': err.msg()
			}
		})
	}

	mf_ctx.log_register(
		path:     '${@FN} ${@FILE_LINE}'
		response: {
			'name':                   recomendation_model.name or { '' }
			'new_recomendation_json': json.encode(recomendation_model.to_safe_log())
		}
	)
}

// send_confirm_email_user_recomendation Confirma a recomendação do usuário
pub fn confirm_user_recomendation(user_email string, recomendation_uuid string) !models.UserRecomendation {
	if !utils.is_valid_uuid(recomendation_uuid) {
		return error('Recomendação não é válida')
	}

	if !utils.validating_email(user_email) {
		return error('Este email não é válido')
	}

	return addapters.adapt_to_model(repository.confirm_user_recomendation(user_email,
		recomendation_uuid)!)
}
