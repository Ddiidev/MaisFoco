document.addEventListener('DOMContentLoaded', function () {
    const recomendationButtons = document.querySelectorAll('.floating-card button');
    const menuToggle = document.getElementById('menu-toggle');
    const dropdownMenu = document.getElementById('dropdown-menu');
    
    recomendationButtons.forEach(button => {
        const targetModel = button.getAttribute('target-model');
        if (targetModel) {
            const modal = document.getElementById(targetModel);
            if (modal) {
                button.addEventListener('click', function () {
                    modal.open();
                });
            }
        }
    });

    if (menuToggle && dropdownMenu) {
        menuToggle.addEventListener('click', function() {
            dropdownMenu.classList.toggle('show');
        });

        document.addEventListener('click', function(event) {
            if (!menuToggle.contains(event.target) && !dropdownMenu.contains(event.target)) {
                dropdownMenu.classList.remove('show');
            }
        });
    }
});