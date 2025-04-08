function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `notification ${'$'}{type}`;
    notification.textContent = message;
    document.body.appendChild(notification);

    setTimeout(() => {
        notification.classList.add('fade-out');
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 500);
    }, 3000);
}