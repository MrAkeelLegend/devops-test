FROM python:3.9-alpine
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# Expose the port that the Flask application will listen on
EXPOSE 5001

# Set the environment variables for AWS Cognito configuration
ENV COGNITO_REGION="us-east-1"
ENV COGNITO_USER_POOL_ID="us-east-1_uOX0QdmfV"
ENV COGNITO_APP_CLIENT_ID="7fftqig4g9vggv0at8mumb4fs"
ENV COGNITO_APP_CLIENT_SECRET="1rnfvoig924vurfkfiq5lg452he178v5audojpjnlh6kmoogf4go"

# Start the Flask application
CMD ["python", "app.py"]
