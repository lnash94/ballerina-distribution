import ballerina/email;
import ballerina/log;

public function main() returns error? {
    email:ImapClient imapClient = check new (
        "imap.email.com", 
        "reader@email.com", 
        "pass456",
        security = email:SSL,
        secureSocket = {
            cert: "../resource/path/to/public.crt"
        }
    );
    do {
        while true {
            email:Message? email = check imapClient->receiveMessage(timeout = 30);
            if email is email:Message {
                log:printInfo("Received an email", subject = email.subject, body = email?.body);
            }
        }
    } on fail var err {
        log:printError(err.message(), stackTrace = err.stackTrace());
        check imapClient->close();
    }
}
