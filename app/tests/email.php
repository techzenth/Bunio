<?php

/* 
 * Here comes the text of your license
 * Each line should be prefixed with  * 
 */
require_once '../../app/plugins/PHPMailer/PHPMailerAutoload.php';

date_default_timezone_set('Etc/UTC');
        $mail = new PHPMailer();

        try {
            $mail->SMTPDebug = 4;
            $mail->Debugoutput = 'html';
            $mail->isSMTP();                                      // Set mailer to use SMTP
            $mail->Host = 'smtp.gmail.com';  // Specify main and backup SMTP servers
            $mail->SMTPAuth = true;                               // Enable SMTP authentication
            //$mail->AuthType = 'XOAUTH2';
            $mail->Username = 'techzenth@gmail.com';                 // SMTP username
            $mail->Password = 'Bunna08an!';                           // SMTP password
            $mail->SMTPSecure = 'ssl';                            // Enable TLS encryption, `ssl` also accepted
            $mail->Port = 465;                                    // TCP port to connect to
            //$mail->isMail();
            $mail->setFrom('techzenth@gmail.com', 'TechZenth');
            $mail->addReplyTo('replyto@techzenth.com', 'Reply To');
            $mail->addAddress('andrebonner@hotmail.com', 'Andre Bonner');
            $mail->Subject = 'PHPMailer Test Subject';
            $mail->msgHTML(file_get_contents('../../app/plugins/PHPMailer/examples/contents.html'));
            // optional - msgHTML will create an alternate automatically
            $mail->AltBody = 'To view the message, please use an HTML compatible email viewer!';
            $mail->addAttachment('../../app/plugins/PHPMailer/examples/images/phpmailer.png'); // attachment
            $mail->addAttachment('../../app/plugins/PHPMailer/examples/images/phpmailer_mini.png'); // attachment
            //$mail->action_function = 'callbackAction';
            if (!$mail->send()) {
                echo "Mailer Error: " . $mail->ErrorInfo;
            } else {
                echo "Message has been sent successfully";
            }
        } catch (phpmailerException $e) {
            echo $e->errorMessage(); //Pretty error messages from PHPMailer
        } catch (Exception $e) {
            echo $e->getMessage(); //Boring error messages from anything else!
        }