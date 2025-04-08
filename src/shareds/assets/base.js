document.addEventListener("DOMContentLoaded", () => {
    const posHtmlElements = document.getElementsByTagName('pos-html');

    Array.from(posHtmlElements).forEach(element => {
        try {
            const htmlString = element.textContent.trim();
            const decodedHtml = new DOMParser().parseFromString(htmlString, 'text/html').body.firstChild;

            if (decodedHtml) {
                element.parentNode.replaceChild(decodedHtml, element);
            }
        } catch (e) {
            console.error("Erro ao transformar o conteúdo em HTML:", e);
        }
    });
});

function convertToEmbed(url) {
    const urlObj = new URL(url);
    
    // Verifica se é um link válido do YouTube
    if (urlObj.hostname === 'www.youtube.com' || urlObj.hostname === 'youtube.com') {
        const videoId = urlObj.searchParams.get('v'); // Obtém o ID do vídeo
        const siParam = urlObj.searchParams.get('si'); // Obtém o parâmetro `si`, se existir

        if (videoId) {
            // Monta o URL embed com o parâmetro `si`, se disponível
            const embedUrl = `https://www.youtube.com/embed/${videoId}${siParam ? `?si=${siParam}` : ''}`;
            return embedUrl;
        }
    }

    // Caso não seja um link válido do YouTube ou não contenha o ID do vídeo
    return null;
}