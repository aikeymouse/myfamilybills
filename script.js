// JavaScript for MyFamilyBills website

// Copy to clipboard functionality
function copyToClipboard(button) {
    const codeBlock = button.parentElement;
    const code = codeBlock.querySelector('code');
    const text = code.textContent;
    
    navigator.clipboard.writeText(text).then(() => {
        // Change button icon to checkmark temporarily
        const icon = button.querySelector('i');
        const originalClass = icon.className;
        icon.className = 'fas fa-check';
        button.classList.add('btn-success');
        button.classList.remove('btn-outline-secondary');
        
        setTimeout(() => {
            icon.className = originalClass;
            button.classList.remove('btn-success');
            button.classList.add('btn-outline-secondary');
        }, 2000);
    }).catch(err => {
        console.error('Failed to copy text: ', err);
        alert('Failed to copy to clipboard');
    });
}

// Smooth scrolling for navigation links
document.addEventListener('DOMContentLoaded', function() {
    // Handle navbar link clicks
    const navLinks = document.querySelectorAll('.navbar-nav .nav-link');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href.startsWith('#')) {
                e.preventDefault();
                const targetId = href.substring(1);
                const targetElement = document.getElementById(targetId);
                if (targetElement) {
                    const navbarHeight = document.querySelector('.navbar').offsetHeight;
                    const targetPosition = targetElement.offsetTop - navbarHeight - 20;
                    
                    window.scrollTo({
                        top: targetPosition,
                        behavior: 'smooth'
                    });
                    
                    // Close mobile menu if open
                    const navbarCollapse = document.querySelector('.navbar-collapse');
                    if (navbarCollapse.classList.contains('show')) {
                        const navbarToggler = document.querySelector('.navbar-toggler');
                        navbarToggler.click();
                    }
                }
            }
        });
    });
    
    // Handle CTA button clicks
    const ctaButtons = document.querySelectorAll('a[href="#installation"]');
    ctaButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const targetElement = document.getElementById('installation');
            if (targetElement) {
                const navbarHeight = document.querySelector('.navbar').offsetHeight;
                const targetPosition = targetElement.offsetTop - navbarHeight - 20;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Add scroll effect to navbar
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', function() {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
            navbar.style.backgroundColor = 'rgba(0, 102, 204, 0.95)';
            navbar.style.backdropFilter = 'blur(10px)';
        } else {
            navbar.classList.remove('scrolled');
            navbar.style.backgroundColor = '';
            navbar.style.backdropFilter = '';
        }
    });
    
    // Animate elements on scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.animation = 'fadeInUp 0.6s ease forwards';
            }
        });
    }, observerOptions);
    
    // Observe feature cards, pricing cards, and installation steps
    const animatedElements = document.querySelectorAll('.feature-card, .pricing-card, .installation-steps');
    animatedElements.forEach(el => {
        // Reset animation initially
        el.style.animation = 'none';
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        observer.observe(el);
    });
    
    // Add loading states to external links
    const externalLinks = document.querySelectorAll('a[target="_blank"]');
    externalLinks.forEach(link => {
        link.addEventListener('click', function() {
            const originalText = this.innerHTML;
            this.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Opening...';
            
            setTimeout(() => {
                this.innerHTML = originalText;
            }, 2000);
        });
    });
});

// Handle form submissions (if any forms are added later)
function handleFormSubmit(formId, callback) {
    const form = document.getElementById(formId);
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            if (callback) {
                callback(new FormData(this));
            }
        });
    }
}

// Utility function for showing notifications
function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} notification-popup`;
    notification.style.cssText = `
        position: fixed;
        top: 100px;
        right: 20px;
        z-index: 9999;
        min-width: 300px;
        animation: slideInRight 0.3s ease;
    `;
    notification.innerHTML = `
        <div class="d-flex align-items-center">
            <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-triangle'} me-2"></i>
            <span>${message}</span>
            <button type="button" class="btn-close ms-auto" onclick="this.parentElement.parentElement.remove()"></button>
        </div>
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 5000);
}

// Add CSS for notification animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    .notification-popup {
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
    }
`;
document.head.appendChild(style);
