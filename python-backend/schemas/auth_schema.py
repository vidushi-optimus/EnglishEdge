from pydantic import BaseModel, EmailStr, field_validator
import re

# -------------------------------
# REGISTER SCHEMA
# -------------------------------
class RegisterRequest(BaseModel):
    username: str
    email: EmailStr   # automatically validates email
    password: str

    # -------------------------------
    # USERNAME VALIDATION
    # -------------------------------
    @field_validator("username")
    def validate_username(cls, value):
        if len(value) < 3:
            raise ValueError("Username must be at least 3 characters long")

        if not value.isalnum():
            raise ValueError("Username must contain only letters and numbers")

        return value

    # -------------------------------
    # PASSWORD VALIDATION
    # -------------------------------
    @field_validator("password")
    def validate_password(cls, value):
        if len(value) < 6:
            raise ValueError("Password must be at least 6 characters long")

        if not re.search(r"[A-Z]", value):
            raise ValueError("Password must contain at least one uppercase letter")

        if not re.search(r"[a-z]", value):
            raise ValueError("Password must contain at least one lowercase letter")

        if not re.search(r"[0-9]", value):
            raise ValueError("Password must contain at least one number")

        if not re.search(r"[!@#$%^&*]", value):
            raise ValueError("Password must contain at least one special character")

        return value


# -------------------------------
# LOGIN SCHEMA
# -------------------------------
class LoginRequest(BaseModel):
    username: str
    password: str