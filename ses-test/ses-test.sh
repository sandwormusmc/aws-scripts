echo -n "Enter username: "
read USERNAME
echo -n "Enter password: "
read PASSWORD
echo -n "Enter FROM e-mail address: "
read FROM 
echo -n "Enter recipient of test e-mail: "
read RCPT
USERNAMEENC=$(echo "$USERNAME" | openssl enc -base64)
PASSWORDENC=$(echo "$PASSWORD" | openssl enc -base64)
openssl s_client -crlf -quiet -connect email-smtp.us-west-2.amazonaws.com:465 << EOF
EHLO tutorgigs.io
AUTH LOGIN
${USERNAMEENC}
${PASSWORDENC}
MAIL FROM: ${FROM}
RCPT TO: ${RCPT}
DATA
From: Test <${FROM}>
To: ${RCPT}
Subject: SES Command Line test

This message was sent using $(basename ${0}).
.
QUIT

EOF
