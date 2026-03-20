from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# 🔴 CHANGE THIS IF NEEDED
SERVER = "OPTLAP-D5268X7Y\\SQLEXPRESS"   # or DESKTOP-XXXXX or .\SQLEXPRESS
DATABASE = "EnglishEdge_DB"

DATABASE_URL = f"mssql+pyodbc://@{SERVER}/{DATABASE}?driver=ODBC+Driver+17+for+SQL+Server"

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()