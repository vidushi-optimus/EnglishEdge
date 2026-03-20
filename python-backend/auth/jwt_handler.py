from passlib.context import CryptContext
from jose import jwt
from datetime import datetime, timedelta

# -------------------------------
# CONFIG
# -------------------------------
SECRET_KEY = "secret123"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# -------------------------------
# PASSWORD FUNCTIONS
# -------------------------------
def hash_password(password: str):
    # 🔥 FIX: bcrypt supports only 72 bytes
    safe_password = password[:72]
    return pwd_context.hash(safe_password)

def verify_password(plain: str, hashed: str):
    # 🔥 FIX: same trimming during verification
    safe_password = plain[:72]
    return pwd_context.verify(safe_password, hashed)

# -------------------------------
# JWT TOKEN FUNCTION
# -------------------------------
def create_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})

    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt
from jose import JWTError

def decode_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except JWTError:
        return None