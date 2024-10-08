from fastapi import APIRouter
from apis import rtc_ffmpeg_test

# 라우터를 연결해주는 역할
api_router = APIRouter()
api_router.include_router(rtc_ffmpeg_test.router, prefix="/rtc", tags=["rtc"])
