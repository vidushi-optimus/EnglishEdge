from sqlalchemy.orm import Session
from domain.user_model import User
from auth.jwt_handler import hash_password, verify_password, create_token
from domain.token_model import BlacklistedToken
# -------------------------------
# REGISTER USER
# -------------------------------
def register_user(db: Session, username: str, email: str, password: str):
    
    # Check if user already exists
    existing_user = db.query(User).filter(User.email == email).first()
    if existing_user:
        return None
   
    # Hash password
    safe_password = password[:72]
    hashed_pw = hash_password(safe_password)

    # Create new user
    new_user = User(
        u_name=username,
        email=email,
        password_hash=hashed_pw,
        role_id=1   # default role
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


# -------------------------------
# LOGIN USER
# -------------------------------
def login_user(db: Session, username: str, password: str):
    
    user = db.query(User).filter(User.u_name == username).first()

    if not user:
        return None

    # 🔥 FIX: trim password before verification
    safe_password = password[:72]

    if not verify_password(safe_password, user.password_hash):
        return None

    # Create JWT token
    token = create_token({"sub": user.u_name})

    return token

def logout_user(db: Session, token: str):
    blacklisted = BlacklistedToken(token=token)

    db.add(blacklisted)
    db.commit()

    return True

def is_token_blacklisted(db: Session, token: str):
    token_entry = db.query(BlacklistedToken).filter(BlacklistedToken.token == token).first()
    return token_entry is not None