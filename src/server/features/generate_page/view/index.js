
function isMobile() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

function openTrailerModal(obj) {
    const url = obj.attributes['data-trailer'].textContent;
    const title = obj.attributes['data-title'].textContent;

    const iframTrailer = document.getElementById('trailer');
    const titleModal = document.getElementById('title-modal');
    const modal = document.getElementById('modal-main');

    titleModal.textContent = title;
    iframTrailer.src = convertToEmbed(url);
    modal.open();
}

function openPage(link) {
    if (link && link.trim() !== '') {
        window.open(link, '_blank');
    }
}

function closeModal() {
    const iframTrailer = document.getElementById('trailer');
    iframTrailer.src = '';
}

function closeRecomendationModal() {}

function toggleCollapse(button) {
    const targetId = button.getAttribute('target-collapse');
    const targetElement = document.getElementById(targetId);

    if (targetElement) {
        const onlyAddScroll = button.hasAttribute('onlyAddScroll');

        if (targetElement.style.maxHeight === '100px') {
            button.textContent = '---- Ver menos ----';
            
            if (onlyAddScroll) {
                targetElement.style.overflowY = 'scroll';
            } else {
                targetElement.style.maxHeight = '250px';
                targetElement.style.overflowY = 'scroll';
            }
        } else {
            button.textContent = '---- Ver mais ----';
            
            if (!onlyAddScroll) {
                targetElement.style.maxHeight = '100px';
            }
            targetElement.style.overflowY = 'hidden';
        }
    }
}

function checkOverflow() {
    const buttons = document.querySelectorAll('.collapsible-button');
    buttons.forEach(button => {
        const targetId = button.getAttribute('target-collapse');
        const targetElement = document.getElementById(targetId);

        if (targetElement) {
            if (targetElement.scrollHeight <= 100) {
                button.style.opacity = '0';
                button.style.pointerEvents = 'none';
            } else {
                button.style.opacity = '1';
                button.style.pointerEvents = 'auto';
            }
        }
    });
}

window.addEventListener('DOMContentLoaded', checkOverflow);