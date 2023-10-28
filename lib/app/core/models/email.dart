import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Email {
  final String _username;
  dynamic smtpServer;

  Email(this._username, String password) {
    smtpServer = gmail(_username, password);
  }

  //Envia um email para o destinatário, contendo a mensagem com o nome do sorteado
  Future<bool> sendMessage({String? mensagem, required String destinatario, String? assunto, List<Attachment>? attachments, String? html}) async {
    print('sendMessage: $mensagem');

    try {
      final message = Message()
        ..from = Address(_username, 'MercadoExpresso')
        ..recipients.add(destinatario)
        ..subject = assunto
        ..text = mensagem
        ..attachments = attachments != null ? attachments : []
        ..html = html;
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());

      return true;
    } on MailerException catch (e) {
      print('Message not sent.');
      print(e.message);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }
}