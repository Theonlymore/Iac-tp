resource "aws_instance" "web_a" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]  
  user_data = <<-EOF
              #!/bin/bash
              # Mise à jour de l'instance
              sudo yum update -y

              # Installation de Docker
              sudo yum install -y docker
              sudo service docker start
              sudo usermod -aG docker ec2-user

              # Création du répertoire pour les microservices
              mkdir /home/ec2-user/microservices
              cd /home/ec2-user/microservices

              # Création de l'API REST
              mkdir api-rest
              cat <<EOM > /home/ec2-user/microservices/api-rest/Dockerfile
              FROM node:16
              WORKDIR /app
              COPY . /app
              RUN npm install axios
              RUN npm install
              EXPOSE 3000
              CMD ["npm", "start"]
              EOM

              cat <<EOM > /home/ec2-user/microservices/api-rest/package.json
              {
                "name": "api-rest",
                "version": "1.0.0",
                "description": "API REST",
                "main": "index.js",
                "scripts": {
                  "start": "node index.js"
                },
                "dependencies": {
                  "express": "^4.17.1",
                  "axios": "^0.27.2"
                },
                "author": "",
                "license": "ISC"
              }
              EOM

              cat <<EOM > /home/ec2-user/microservices/api-rest/index.js
              const express = require('express');
              const axios = require('axios');
              const app = express();
              const port = 3000;

              app.get('/', (req, res) => {
                res.send('Hello from Node.js API REST!');
              });

              // Route pour appeler le backend
              app.get('/get-backend', async (req, res) => {
                try {
                  const response = await axios.get('http://backend:5000');
                  res.send("Backend says: " + response.data);
                } catch (error) {
                  res.status(500).send('Error communicating with backend');
                }
              });

              app.listen(port, () => {
                console.log("API REST listening at http://localhost:" + port);
              });
              EOM

              # Création du backend Node.js
              mkdir backend
              cat <<EOM > /home/ec2-user/microservices/backend/Dockerfile
              FROM node:16
              WORKDIR /app
              COPY . /app
              RUN npm install express
              EXPOSE 5000
              CMD ["node", "app.js"]
              EOM

              cat <<EOM > /home/ec2-user/microservices/backend/package.json
              {
                "name": "backend",
                "version": "1.0.0",
                "description": "Backend Node.js",
                "main": "app.js",
                "scripts": {
                  "start": "node app.js"
                },
                "dependencies": {
                  "express": "^4.17.1"
                },
                "author": "",
                "license": "ISC"
              }
              EOM

              cat <<EOM > /home/ec2-user/microservices/backend/app.js
              const express = require('express');
              const app = express();
              const port = 5000;

              app.get('/', (req, res) => {
                res.send('Hello from Node.js Backend!');
              });

              app.listen(port, () => {
                console.log("Backend esgi listening at http://localhost:" + port);
              });
              EOM

              # Création du backend Node.js
              mkdir notif
              cat <<EOM > /home/ec2-user/microservices/notif/Dockerfile
              FROM node:16
              WORKDIR /app
              COPY . /app
              RUN npm install express
              EXPOSE 5000
              CMD ["node", "app.js"]
              EOM

              cat <<EOM > /home/ec2-user/microservices/notif/app.js
              const mysql = require('mysql2');
              const axios = require('axios');

              // Configurations pour la base de données RDS
              const dbConfig = {
                host: process.env.RDS_ENDPOINT,
                user: process.env.RDS_USERNAME,
                password: process.env.RDS_PASSWORD,
                database: process.env.RDS_DB_NAME
              };

              // Webhook Discord
              const discordWebhookUrl = process.env.DISCORD_WEBHOOK_URL;

              // Fonction pour envoyer le webhook à Discord
              const sendDiscordNotification = async (message) => {
                try {
                  await axios.post(discordWebhookUrl, {
                    content: message
                  });
                  console.log("Message envoyé à Discord");
                } catch (error) {
                  console.error("Erreur d'envoi du message à Discord : ", error);
                }
              };

              // Fonction pour surveiller les changements dans la base de données
              const monitorDatabase = () => {
                const connection = mysql.createConnection(dbConfig);

                connection.connect((err) => {
                  if (err) {
                    console.error('Erreur de connexion à la base de données:', err);
                    return;
                  }
                  console.log('Connecté à la base de données RDS');
                });

                // Polling pour vérifier les changements toutes les 10 secondes
                setInterval(async () => {
                  try {
                    const [rows] = await connection.promise().query('SELECT * FROM your_table WHERE condition_column = ? LIMIT 1', [yourCondition]);
                    if (rows.length > 0) {
                      sendDiscordNotification('Un changement a été détecté dans la base de données!');
                    }
                  } catch (error) {
                    console.error('Erreur lors de la vérification des changements :', error);
                  }
                }, 10000);  // Vérifier toutes les 10 secondes
              };

              // Lancer la surveillance
              monitorDatabase();
              EOM

              # Construction des images Docker pour l'API REST et le backend
              cd /home/ec2-user/microservices
              docker build -t api-rest ./api-rest
              docker build -t notif ./notif
              docker build -t backend ./backend

              # Création du réseau Docker bridge
              docker network create --driver bridge my-bridge-network

              # Lancement des conteneurs
              docker run -d --network my-bridge-network --name api-rest -p 80:3000 api-rest
              docker run -d --network my-bridge-network --name backend backend
              docker run -d --network my-bridge-network --name notif notif

              echo "Configuration terminée."
              EOF

  tags = {
    Name = "web-instance-a"
  }
}

