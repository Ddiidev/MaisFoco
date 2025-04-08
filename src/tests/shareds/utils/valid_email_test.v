module utils

import src.shareds.utils as shareds_utils

fn test_validating_email() {
	// Valid email cases with real domains
	assert shareds_utils.validating_email('user@gmail.com')
	assert shareds_utils.validating_email('user.name@outlook.com')
	assert shareds_utils.validating_email('user-name@yahoo.com')
	assert shareds_utils.validating_email('user.123@hotmail.com')
	assert shareds_utils.validating_email('business@microsoft.com')
	assert shareds_utils.validating_email('contact@amazon.com')
	assert shareds_utils.validating_email('developer@apple.com')
	assert shareds_utils.validating_email('info@ibm.com')

	// Valid email cases with subdomains
	assert shareds_utils.validating_email('user@mail.google.com')
	assert shareds_utils.validating_email('support@help.github.com')

	// Invalid email cases
	assert !shareds_utils.validating_email('') // Empty string
	assert !shareds_utils.validating_email('invalid email@gmail.com') // Contains space
	assert !shareds_utils.validating_email('@outlook.com') // No username
	assert !shareds_utils.validating_email('user@') // No domain
	assert !shareds_utils.validating_email('user@invalid') // Incomplete domain
	assert !shareds_utils.validating_email('user.gmail.com') // Missing @
}
