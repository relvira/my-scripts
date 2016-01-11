#/usr/bin/python python
# -*- coding: utf-8 -*-

import smtplib,random,os


fromaddr = os.environ.get('HR_SCRIPT_EMAIL')
frompasswd = os.environ.get('HR_SCRIPT_PASSWD')
toaddr  = 'relviratellez@gmail.com'

msgs = [
    "Hola! \n¿Podríais enviarme la nómina de este último mes? \n\nSaludos,\nRafa.",
    "Buenos días, \nEnviarme cuando podáis la nómina del último mes. \n\nGracias, \nRafa.",
    "Buenas, \n¿Podéis enviarme la nómina del último mes? \n\nGracias! \nRafa."
]

if fromaddr is None or frompasswd is None:
    print "HR_SCRIPT_EMAIL OR HR_SCRIPT_PASSWD not defined!"
else:
    randMsg = random.choice(msgs)

    # Compose mail msg
    msg = "\r\n".join([
        "From: "+fromaddr,
        "To: "+toaddr,
        "Subject: Nómina último mes",
        "",
        randMsg
    ])

    # Send email!
    server = smtplib.SMTP('smtp.gmail.com:587')
    server.starttls()
    server.login(fromaddr,frompasswd)
    server.sendmail(fromaddr, toaddr, msg)
    server.quit()
    print "Sent email to "+toaddr+" saying: \n" + randMsg
