# Configure Gmail as Relay Host
### Installing packages
```
sudo apt install mailutils postfix
```
```
sudo vi /etc/postfix/main.cf

relayhost= [smtp.gmail.com]:587
myhostname= <Host_Name>
```

## 1. Configure gmail credentials
Go to https://myaccount.google.com -> search "app password"

1. Enter app name
2. copy password (remove spaces in password)

## 2. Setting relay host credentials

```
sudo vi /etc/postfix/sasl_passwd

[smtp.gmail.com]:587 <Email_Id>:<Password>
```
1. Set permission of sasl_passwd file
```
chmod 600 /etc/postfix/sasl_passwd
```
2. Generate the postfix lookup table
```
sudo postmap /etc/postfix/sasl_passwd
```
3. Enable SASL authN for postfix
```
sudo vi /etc/postfix/main.cf

smtp_tls_security_level = encrypt
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
```
## 3. Restart postfix
```
sudo systemctl restart postfix
```

## 4. Test Email Sending
1. Using mail command
```
echo "Test email body" | mail -s "Test E-mail" <Reciepant mail-id>
```
2. Using sendmail
```
sendmail <Reciepant mail-id> <<EOF
From: no-reply-cof@max.com
To: <Reciepant mail-id>
Subject: HTML Format Document
Content_Type: text/html

$(cat ./<HTML_file>)
EOF
```