function isMobile() {
    if (typeof window === 'undefined') return false;

    const mobileRegex = /(android|iphone|ipad|mobile|phone|tablet)/i;

    return (
        mobileRegex.test(navigator.userAgent) ||
        (window.innerWidth <= 768) // Additional check for screen width
    );
};
