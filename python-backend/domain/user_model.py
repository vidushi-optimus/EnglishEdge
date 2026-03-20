from sqlalchemy import Column, Integer, String, DateTime, Boolean
from infrastructure.database import Base

class User(Base):
    __tablename__ = "Users"

    user_id = Column(Integer, primary_key=True, index=True)
    u_name = Column(String(100))
    email = Column(String(150), unique=True)
    password_hash = Column(String(255))
    role_id = Column(Integer)