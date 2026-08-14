from functools import wraps
from flask import session, redirect, url_for, flash, render_template, request
from werkzeug.security import generate_password_hash, check_password_hash

def hash_password(password):
    """Generate secure hash for password."""
    return generate_password_hash(password)

def verify_password(hashed_password, password):
    """
    Verify plain text password against stored hash.
    Also provides backwards fallback for test hashes if needed.
    """
    if not hashed_password:
        return False
    try:
        return check_password_hash(hashed_password, password)
    except Exception:
        # Simple fallback check if string is plain text (for initial dev testing)
        return hashed_password == password

def login_required(f):
    """Decorator to enforce authentication on routes."""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please log in to access this page.', 'warning')
            return redirect(url_for('login', next=request.url))
        return f(*args, **kwargs)
    return decorated_function

def admin_required(f):
    """Decorator to enforce Admin role on routes."""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please log in to access this page.', 'warning')
            return redirect(url_for('login'))
        if session.get('role') != 'Admin':
            flash('Access denied. Administrator privileges required.', 'danger')
            return render_template('403.html'), 403
        return f(*args, **kwargs)
    return decorated_function

def role_required(allowed_roles):
    """Decorator to enforce specific roles on routes."""
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if 'user_id' not in session:
                flash('Please log in to access this page.', 'warning')
                return redirect(url_for('login'))
            if session.get('role') not in allowed_roles:
                flash('Access denied. You do not have permission to perform this action.', 'danger')
                return render_template('403.html'), 403
            return f(*args, **kwargs)
        return decorated_function
    return decorator
