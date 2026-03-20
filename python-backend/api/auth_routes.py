from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import text

from infrastructure.database import SessionLocal
from schemas.auth_schema import RegisterRequest, LoginRequest
from application.auth_service import register_user, login_user

router = APIRouter()

# -------------------------------
# DATABASE DEPENDENCY
# -------------------------------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# -------------------------------
# TEST DATABASE CONNECTION
# -------------------------------
@router.get("/test-db")
def test_db(db: Session = Depends(get_db)):
    try:
        db.execute(text("SELECT 1"))
        return {"message": "Database connected successfully"}
    except Exception as e:
        return {"error": str(e)}

# -------------------------------
# REGISTER API
# -------------------------------
@router.post("/register")
def register(request: RegisterRequest, db: Session = Depends(get_db)):
    
    user = register_user(db, request.username, request.email, request.password)

    if not user:
        raise HTTPException(status_code=400, detail="User already exists")

    return {"message": "User registered successfully"}

# -------------------------------
# LOGIN API
# -------------------------------
@router.post("/login")
def login(request: LoginRequest, db: Session = Depends(get_db)):
    
    token = login_user(db, request.username, request.password)

    if not token:
        raise HTTPException(status_code=400, detail="Invalid credentials")

    return {"access_token": token}
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from application.auth_service import logout_user

security = HTTPBearer()

# -------------------------------
# LOGOUT API
# -------------------------------
@router.post("/logout")
def logout(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
):
    token = credentials.credentials

    logout_user(db, token)

    return {"message": "Logged out successfully"}
from auth.dependencies import get_current_user

# -------------------------------
# PROTECTED ROUTE
# -------------------------------
@router.get("/protected")
def protected_route(user: str = Depends(get_current_user)):
    return {
        "message": f"Welcome {user}, you are authorized 🎉"
    }