import uuid
from flask import Flask, render_template, request, flash, redirect
import boto3

import hmac
import hashlib
import base64

app = Flask(__name__)
app.secret_key = 'yjioio98Uihdiklu'

LOGGED_IN = False



# AWS Cognito configuration
COGNITO_REGION = 'us-east-1'
COGNITO_USER_POOL_ID = 'us-east-1_8q7WbmCah'
COGNITO_APP_CLIENT_ID = '4lkrkfeorfhlp0coig0167hkbu'
COGNITO_APP_CLIENT_SECRET = '1de2alvniah2d6hneic812lq7nrqmftmpki84lkv8jsn0s7vutd'




cognito_client = boto3.client('cognito-idp', region_name=COGNITO_REGION)
LOGGED_IN = False


@app.route('/')
def home():
    return 'Welcome to the Home Page'


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']


        message = email + COGNITO_APP_CLIENT_ID
        digest = hmac.new(COGNITO_APP_CLIENT_SECRET.encode('utf-8'), message.encode('utf-8'), hashlib.sha256).digest()
        secret_hash = base64.b64encode(digest).decode()
        
        try:
            # User creation in AWS COgnito user pool
            response = cognito_client.sign_up(
                ClientId=COGNITO_APP_CLIENT_ID,
                SecretHash=secret_hash,
                Username=email,
                Password=password,
                UserAttributes=[
                    {'Name': 'email', 'Value': email},
                ]
            )

            flash('Registration successful! Please check your email for verification.', 'success')
            return redirect('/')
        except cognito_client.exceptions.UsernameExistsException:
            flash('Email already registered. Please log in or use a different email.', 'error')
    return render_template('register.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        
        try:
            response = cognito_client.initiate_auth(
                ClientId=COGNITO_APP_CLIENT_ID,
                AuthFlow='USER_PASSWORD_AUTH',
                AuthParameters={
                    'USERNAME': email,
                    'PASSWORD': password
                }
            )

            flash('Login successful!', 'success')

            global LOGGED_IN
            LOGGED_IN = True
            # Perform any additional actions after successful login
            return redirect('/members')
        except cognito_client.exceptions.UserNotFoundException:
            flash('Invalid email or password.', 'error')
        except cognito_client.exceptions.NotAuthorizedException:
            flash('Invalid email or password.', 'error')
    return render_template('login.html')



@app.route('/members')
def members_only():
    if LOGGED_IN:
        return render_template('members.html')
    else:
        return redirect('/login')



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)