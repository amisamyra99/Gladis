import os
import uvicorn
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from google.api_core.client_options import ClientOptions
import google.generativeai as genai
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()

today=datetime.today().strftime('%m-%d-%Y %H:%M:%S')

GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
if GOOGLE_API_KEY is None:
    raise ValueError("GOOGLE_API_KEY environment variable not set")


# Set up client options with your API key
client_options = ClientOptions(api_key=GOOGLE_API_KEY)
genai.configure(client_options=client_options)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

model = genai.GenerativeModel("models/gemini-1.5-pro-latest", system_instruction=[
        "Your are an  intent classifier  \
        use the text input to extract user intent and match with the following intents=['create_appointment', 'delete_appointment','modify_appointment','check_meeting','unknown'] take synonym into account\
        if you do not know in which category to classify the text classify it unknown\
        return a json for with the user intents\
        user_intent:{user_intent} ",],)

model_entity_extraction=genai.GenerativeModel("models/gemini-1.5-pro-latest", system_instruction=[
        "Your are an  entity extracter \
        use the text input to extract user calendar information\
        return one json output format with the following information\
        if the user omits some obvious information for example the years consider the actual year.\
            "+today+
        "if the user use weekday take day as reference and extract the corresponding date and \
        store it put default star time 12am end startime + 1hour\
        date format should be MM/dd/yyyy\
        from and to format should be HH:mm \
        date:{date} ,from:{startime},to:{endTime},reason: {reason},location:{location}",],)
print(model_entity_extraction)
@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/intent_classifier")
async def handle_input(request: Request):
    try:
        data = await request.json()
        user_input = data.get("user_input")
        print(user_input)
        if user_input is None:
            return JSONResponse({"error": "Missing 'user_input' in request body"}, status_code=400)

        response = model.generate_content(user_input)
        response_text = response.text
        return {"answer": response_text}
    except Exception as e:
        return JSONResponse({"error": str(e)}, status_code=500)
    

@app.post("/entity_extraction")
async def handle_input_entity_extraction(request: Request):
    try:
        data = await request.json()
        user_input = data.get("user_input")
        print(user_input)
        if user_input is None:
            return JSONResponse({"error": "Missing 'user_input' in request body"}, status_code=400)

        response = model_entity_extraction.generate_content(user_input)
        response_text = response.text
        print(response_text)
        return {"answer": response_text}
    except Exception as e:
        return JSONResponse({"error": str(e)}, status_code=500)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)


#commamd
"""
uvicorn app:app --reload
choco install ngrok
ngrok http http://127.0.0.1:8000

"""