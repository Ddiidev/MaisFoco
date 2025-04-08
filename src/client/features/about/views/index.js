document.addEventListener('DOMContentLoaded', () => {
    const collapsibleHeaders = document.querySelectorAll('.collapsible-header');

    collapsibleHeaders.forEach(header => {
        header.addEventListener('click', () => {
            const section = header.closest('.collapsible-section');
            const content = section.querySelector('.collapsible-content');
            const isExpanded = content.classList.contains('expanded');

            content.classList.toggle('expanded');
            header.setAttribute('aria-expanded', !isExpanded);
        });
    });
});