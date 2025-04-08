module utils

import src.shareds.utils as shareds_utils

fn test_validate_phone_number_valid_10_digits() {
	assert shareds_utils.validate_phone_number('1122334455')
	assert shareds_utils.validate_phone_number('11-2233-4455')
	assert shareds_utils.validate_phone_number('(11) 2233-4455')
}

fn test_validate_phone_number_valid_11_digits() {
	assert shareds_utils.validate_phone_number('11923334444')
	assert shareds_utils.validate_phone_number('11-9-2333-4444')
	assert shareds_utils.validate_phone_number('(11) 9-2333-4444')
}

fn test_validate_phone_number_invalid_length() {
	assert !shareds_utils.validate_phone_number('123456789') // 9 digits
	assert !shareds_utils.validate_phone_number('123456789012') // 12 digits
	assert !shareds_utils.validate_phone_number('') // empty
}

fn test_validate_phone_number_invalid_area_code() {
	assert !shareds_utils.validate_phone_number('0922334455') // area code < 10
	assert !shareds_utils.validate_phone_number('0023334444') // area code < 10
	assert !shareds_utils.validate_phone_number('0092333444') // area code < 10
}

fn test_validate_phone_number_invalid_mobile_prefix() {
	assert !shareds_utils.validate_phone_number('11823334444') // invalid mobile prefix (8)
	assert !shareds_utils.validate_phone_number('11723334444') // invalid mobile prefix (7)
}

fn test_validate_phone_number_invalid_characters() {
	assert !shareds_utils.validate_phone_number('1122abc333') // contains letters
	assert !shareds_utils.validate_phone_number('11@22334455') // contains special characters
	assert !shareds_utils.validate_phone_number('11.22334455') // contains dots
}
