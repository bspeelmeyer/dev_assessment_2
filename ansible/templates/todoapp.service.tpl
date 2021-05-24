[Unit]
Description=ToDoApp
Requires=network-online.target
After=network-online.target

[Service]
Environment='DB_URL=mongodb://{{ db_user }}:{{ db_pass }}@{{ db_url }}:{{ db_port }}'
Environment='SESSION_SECRET=secret'
WorkingDirectory=/home/ec2-user/package
Type=simple
ExecStart=/home/ec2-user/.nvm/versions/node/v16.2.0/bin/node server.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
