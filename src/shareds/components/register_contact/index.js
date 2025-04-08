let registerContractTokens = { email: "", whatsapp: "" };
let emailCaptchaId = null;
let whatsappCaptchaId = null;
let isEmailLoading = false;
let isWhatsAppLoading = false;

// 🔹 Função para gerar token antes de enviar o email
function generateEmailToken() {
    const emailInput = document.getElementById('idContactEmail');
    const email = emailInput.value.trim();

    console.log(email)
    if (!email) {
        showNotification('Por favor, digite seu email.', 'error');
        return;
    }

    if (!isValidEmail(email)) {
        showNotification('Por favor, digite um email válido.', 'error');
        return;
    }
    
    if (!emailCaptchaId) {
        emailCaptchaId = turnstile.render("#captcha-email", {
            sitekey: "0x4AAAAAABABQGopHB4AALWc",
            callback: (token) => {
                registerContractTokens.email = token;
                console.log("Token de email:", token);
                handleEmailSubmit();
            }
        });
    } else {
        turnstile.reset(emailCaptchaId);
    }
}

// 🔹 Função para gerar token antes de enviar WhatsApp
function generateWhatsAppToken() {
    const whatsappInput = document.getElementById('idContactWhatsApp');
    const whatsapp = whatsappInput.value.trim();

    if (!whatsapp) {
        showNotification('Por favor, digite seu número do WhatsApp.', 'error');
        return;
    }

    if (!isValidWhatsApp(whatsapp)) {
        showNotification('Por favor, digite um número de WhatsApp válido.', 'error');
        return;
    }

    if (!whatsappCaptchaId) {
        whatsappCaptchaId = turnstile.render("#captcha-whatsapp", {
            sitekey: "0x4AAAAAABABQGopHB4AALWc",
            callback: (token) => {
                registerContractTokens.whatsapp = token;
                handleWhatsAppSubmit();
            }
        });
    } else {
        console.log('reset')
        turnstile.reset(whatsappCaptchaId);
    }
}

// 🔹 Função para enviar email após validar reCAPTCHA
function handleEmailSubmit() {
    if (!registerContractTokens.email || isEmailLoading) {
        return;
    }

    const emailInput = document.getElementById('idContactEmail');
    const submitButton = emailInput.nextElementSibling;
    const email = emailInput.value.trim();

    if (!email || !isValidEmail(email)) {
        return;
    }

    isEmailLoading = true;
    submitButton.innerHTML = '<span class="spinner"></span> Enviando...';
    submitButton.disabled = true;

    fetch('/api/v1/register_contact/email', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            email,
            recaptchaToken: registerContractTokens.email
        })
    })
        .then(response => response.json())
        .then(data => {
            showNotification(data.msg);
            emailInput.value = '';
            turnstile.reset(emailCaptchaId);
            registerContractTokens.email = '';
        })
        .catch(error => {
            console.error('Erro:', error);
            showNotification('Erro ao registrar email. Tente novamente.', 'error');
            turnstile.reset(emailCaptchaId);
            registerContractTokens.email = '';
        })
        .finally(() => {
            isEmailLoading = false;
            submitButton.innerHTML = 'Enviar';
            submitButton.disabled = false;
        });
}

// 🔹 Função para enviar WhatsApp após validar reCAPTCHA
function handleWhatsAppSubmit() {
    if (!registerContractTokens.whatsapp || isWhatsAppLoading) {
        return;
    }

    const whatsappInput = document.getElementById('idContactWhatsApp');
    const submitButton = whatsappInput.nextElementSibling;
    const whatsapp = whatsappInput.value.trim();

    if (!whatsapp || !isValidWhatsApp(whatsapp)) {
        return;
    }

    isWhatsAppLoading = true;
    submitButton.innerHTML = '<span class="spinner"></span> Enviando...';
    submitButton.disabled = true;

    fetch('/api/v1/register_contact/whatsapp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            recaptchaToken: registerContractTokens.whatsapp,
            whatsapp
        })
    })
        .then(response => response.json())
        .then(data => {
            showNotification(data.msg);
            whatsappInput.value = '';
            turnstile.reset(whatsappCaptchaId);
            registerContractTokens.whatsapp = '';
        })
        .catch(error => {
            console.error('Erro:', error);
            showNotification('Erro ao registrar WhatsApp. Tente novamente.', 'error');
            turnstile.reset(whatsappCaptchaId);
            registerContractTokens.whatsapp = '';
        })
        .finally(() => {
            isWhatsAppLoading = false;
            submitButton.innerHTML = 'Enviar';
            submitButton.disabled = false;
        });
}

function isValidEmail(email) {
    if (!email || typeof email !== "string") return false;

    const atIndex = email.indexOf("@@");
    if (atIndex < 1 || atIndex !== email.lastIndexOf("@@")) return false; // Deve ter um único '@'

    const localPart = email.substring(0, atIndex);
    const domainPart = email.substring(atIndex + 1);

    if (localPart.length === 0 || domainPart.length < 3) return false; // Domínio precisa ter pelo menos "a.b"

    const dotIndex = domainPart.indexOf(".");
    if (dotIndex <= 0 || dotIndex === domainPart.length - 1) return false; // O '.' deve estar em uma posição válida

    return true;
}

function isValidWhatsApp(number) {
    const cleanNumber = number.replace(/\D/g, '');

    // Check if it has 10 or 11 digits (including area code)
    if (cleanNumber.length < 10 || cleanNumber.length > 11) {
        return false;
    }

    // Check if the area code is valid (11-99)
    const areaCode = parseInt(cleanNumber.substring(0, 2));
    if (areaCode < 11 || areaCode > 99) {
        return false;
    }

    // For 11-digit numbers, check if the ninth digit is 9
    if (cleanNumber.length === 11 && cleanNumber[2] !== '9') {
        return false;
    }

    return true;
}