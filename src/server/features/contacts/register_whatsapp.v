module contacts

import recaptcha
import mf_core.utils
import mf_core.conf_env
import mf_core.context_service
import mf_core.features.contacts.entities
import mf_core.features.contacts.repository
import mf_core.log_observoo.models as log_models

pub fn register_whatsapp(mut mf_ctx context_service.ContextService, recaptcha_token string, whatsapp string) ! {
	env := conf_env.load_env()
	response := recaptcha.new(token: recaptcha_token, secret_key: env.recaptcha_secret) or {
		mf_ctx.log_register(log_models.ContractTypeRegister{
			path: 'VALIDACAO_RECAPTCHA_WHATSAPP'
			list_error: {
				'code':    err.code().str()
				'message': err.msg()
			}
		})

		return err
	}

	if response.is_valid() {
		if !utils.validate_phone_number(whatsapp) {
			mf_ctx.log_register(log_models.ContractTypeRegister{
				path: 'VALIDACAO_NUMERO_WHATSAPP'
				list_error: {
					'code':    '0'
					'message': 'Número de whatsapp inválido (${whatsapp})'
				}
			})

			return error('Número de whatsapp inválido')
		}

		repository.insert(entities.Contact{
			whatsapp: whatsapp
		}) or {
			mf_ctx.log_register(log_models.ContractTypeRegister{
				path: 'INSERCAO_CONTATO_WHATSAPP'
				list_error: {
					'code':    err.code().str()
					'message': err.msg()
				}
			})

			return err
		}
	} else {
		mf_ctx.log_register(log_models.ContractTypeRegister{
			path: 'FALHA_RECAPTCHA_WHATSAPP'
			list_error: {
				'code':    '0'
				'message': 'Ocorreu uma falha ao autenticar o recaptcha'
			}
		})

		return error('Ocorreu uma falha ao autenticar o recaptcha')
	}

	mf_ctx.log_register(
		path: 'REGISTRO_WHATSAPP_SUCESSO'
		response: {
			'regster_contact_whatsapp': whatsapp
		}
	)
}
