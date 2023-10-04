#!/bin/bash
sudo yum install wget unzip httpd -y
mkdir -p /tmp/webfiles
cd /tmp/webfiles
wget https://www.tooplate.com/zip-templates/2098_health.zip
unzip 2098_health
rm -rf 2098_health.zip
cd 2098_health
cp -r * /var/www/html/
systemctl start httpd
systemctl enable httpd
rm -rf /tmp/webfiles



// #!/bin/bash

// # Install Apache on Ubuntu
// sudo yum check-update
// sudo yum -y update
// # apache installation, enabling and status check
// sudo yum -y install httpd
// sudo systemctl start httpd
// sudo systemctl enable httpd
// sudo systemctl status httpd | grep Active
// # firewall installation, start and status check
// sudo yum install firewalld
// sudo systemctl start firewalld
// sudo systemctl status firewalld | grep Active
// # adding http services
// sudo firewall-cmd — permanent — add-service=http
// # reloading the firewall
// sudo firewall-cmd — reload


// sudo cat > /var/www/html/index.html << EOF
// <html>
// <head>
//   <title> A-LPHARMACIST </title>
// </head>
// <body>
//   <p> HELLO WORLD FROM A-LPHARMACIST DEVOPS ENGINEER
// </body>
// </html>
// EOF

