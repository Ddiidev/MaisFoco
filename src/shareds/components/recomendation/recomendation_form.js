let turnstileToken = null;
let captchaId = null;
let isLoading = false;

main();

function main() {
    const tooltipArticles = document.getElementById('tooltip-data-movie')
    tooltipArticles.style.display = 'hidden';
    
    if (isMobile()) {
        tooltipArticles.style.display = 'inline-block';
    }
}

function isMobile() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

function handleTurnstileCallback(token) {
    turnstileToken = token;
}

// @include '/src/shareds/assets/utils/notifications.js'

function sendRecomendation() {
    // Prevent default form submission
    event.preventDefault();

    const submitButton = document.getElementById('submitButton');
    submitButton.innerHTML = '<span class="spinner"></span> Enviando...';
    submitButton.disabled = true;

    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const category = document.querySelector('input[name="category"]:checked')?.value;
    const contentLink = document.getElementById('content-link').value;

    if (!name || !email || !category || !contentLink) {
        showNotification('Por favor, preencha todos os campos obrigatórios.', 'error');
        return;
    }

    if (!isValidEmail(email)) {
        showNotification('Por favor, digite um email válido.', 'error');
        return;
    }

//    @if env_dev
        turnstileToken = 'env_dev';
        handleRecomendationSubmit();
//    @else
    if (!captchaId) {
        captchaId = turnstile.render(".cf-turnstile", {
            sitekey: "0x4AAAAAABABQGopHB4AALWc",
            callback: (token) => {
                turnstileToken = token;
                handleRecomendationSubmit();
            }
        });
    } else {
        turnstile.reset(captchaId);
    }
//    @end
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

function handleRecomendationSubmit() {
    if (!turnstileToken || isLoading) {
        showNotification('Por favor, complete a verificação do Cloudflare para prosseguir.', 'error');
        return;
    }

    const submitButton = document.querySelector('button[type="submit"]');
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const category = document.querySelector('input[name="category"]:checked').value;
    const contentLink = document.getElementById('content-link').value;
    const observation = document.getElementById('observation').value;

    isLoading = true;
    submitButton.innerHTML = '<span class="spinner"></span> Enviando...';
    submitButton.disabled = true;

    // Create request body
    const data = {
        name: name,
        email: email,
        category: category,
        link: contentLink,
        observation: observation,
        recaptchaToken: turnstileToken
    };

    // Send POST request
    fetch('/api/v1/user-recomendation', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
    })
    .then(response => {
        if (!response.ok) {
            // Parse error response from server
            return response.json().then(errorData => {
                throw new Error(errorData.error || 'Erro desconhecido');
            });
        }
        return response.json();
    })
    .then(data => {
        showNotification('Recomendação enviada com sucesso! Obrigado pela contribuição! 🎉');
        congratulations();
        // Reset the form and turnstile token
        document.querySelector('form').reset();
        turnstileToken = null;
        turnstile.reset(captchaId);
    })
    .catch(error => {
        turnstile.reset(captchaId);
    })
    .finally(() => {
        isLoading = false;
        submitButton.innerHTML = 'Enviar Recomendação';
        submitButton.disabled = false;
    });
}

function congratulations() {
    var end = Date.now() + (8 * 300);

    var colors = ['#25d366', '#f8b01f'];

    (function frame() {
        confetti({
            particleCount: 2,
            angle: 60,
            spread: 55,
            origin: { x: 0 },
            colors: colors
        });
        confetti({
            particleCount: 2,
            angle: 120,
            spread: 55,
            origin: { x: 1 },
            colors: colors
        });

        if (Date.now() < end) {
            requestAnimationFrame(frame);
        }
    }());
}