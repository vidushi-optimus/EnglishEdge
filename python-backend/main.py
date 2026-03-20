from fastapi import FastAPI
from infrastructure.database import engine, Base
from api.auth_routes import router as auth_router

app = FastAPI()



# Include routes
app.include_router(auth_router)