from sqlalchemy import Column, Integer, String, DateTime
from infrastructure.database import Base
from datetime import datetime

class BlacklistedToken(Base):
    __tablename__ = "BlacklistedTokens"

    id = Column(Integer, primary_key=True, index=True)
    token = Column(String, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)