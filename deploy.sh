echo "#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user

mkdir app
cd app
echo \"from flask import Flask
app = Flask(__name__)
@app.route('/')
def home():
    return 'Hola Mundo desde script automatizado!'
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
\" > app.py

echo \"FROM python:3.9
RUN pip install flask
COPY . /app
WORKDIR /app
CMD [\\\"python\\\", \\\"app.py\\\"]\" > Dockerfile

docker build -t auto-app .
docker run -d -p 80:80 auto-app

PUBLIC_IP=\$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

echo \"La app está disponible en: http://\$PUBLIC_IP\"
" > deploy.sh
