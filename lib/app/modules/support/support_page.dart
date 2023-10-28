import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/modules/support/support_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:math' as math;

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends ModularState<SupportPage, SupportStore> {
  final MainStore mainStore = Modular.get();
  final ScrollController scrollController = ScrollController();

  bool visibleSupport = true;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          visibleSupport == false) {
        setState(() {
          visibleSupport = true;
        });
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          visibleSupport == true) {
        setState(() {
          visibleSupport = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: scrollController,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top + wXD(60, context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    wXD(18, context),
                    wXD(16, context),
                    0,
                    wXD(0, context),
                  ),
                  child: Text(
                    "Como podemos ajudar?",
                    style: textFamily(
                      context,
                      fontSize: 16,
                      color: getColors(context).onBackground,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: wXD(362, context),
                    padding: EdgeInsets.symmetric(
                        horizontal: wXD(18, context),
                        vertical: wXD(18, context)),
                    margin: EdgeInsets.only(top: wXD(15, context)),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: getColors(context).primary.withOpacity(.3)),
                      color: getColors(context).surface,
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: wXD(11, context)),
                          child: Text(
                            "Perguntas frequentes",
                            style: textFamily(
                              context,
                              fontSize: 15,
                              color: getColors(context).onBackground,
                            ),
                          ),
                        ),
                        Question(
                          title: "O que é a MercadoExpresso?",
                          answer:
                              """A MercadoExpresso é uma nova maneira de fazer compras online. Você faz o download do aplicativo MercadoExpresso para iOS ou Android agora mesmo, e realiza pedidos que poderão chegar até você dentro de até 90 minutos.

Navegue pelas categorias ou utilize a barra de pesquisa para encontrar o que você procura. Depois é só adicionar no carrinho de compras, confirmar o pagamento e pronto! Um Agente se encarregará de trazer seu pedido em suas mãos.
""",
                        ),
                        Question(
                          title:
                              "Que tipo de produtos eu encontro na MercadoExpresso?",
                          answer:
                              """A disponibilidade de produtos dependerá da sua localização, mas na plataforma você poderá encomendar praticamente qualquer tipo de produto, por exemplo, das seguintes categorias:

Óculos de grau, Roupas e Acessórios, Eletrônicos, Games, Brinquedos, Material Escolar, Peças de Carro, Peças de Bicicletas, Caça e Pesca, Produtos Eróticos, Livros, Presentes diversos (como cesta de café da manhã), Pet, Materiais Esportivos, Ferramentas e Utensílios de casa e cozinha, Perfumaria, Drogaria, Cuidados Pessoais, etc.
Se mesmo assim você não encontrar o que procura, por favor, nos dê seu feedback através do suporte no aplicativo ou através do email suporte@mercadoexpresso.com.br. Teremos o maior prazer em atendê-lo para melhorar cada vez mais nossa prestação de serviço em sua região.
""",
                        ),
                        Question(
                          title:
                              "Quais são os métodos de pagamento aceitos pela MercadoExpresso?",
                          answer:
                              """Nós aceitamos cartões de crédito nacionais e internacionais, desde que estejam registrados aqui no Brasil e PIX. Na tela de finalização da compra é possível optar pelo método de pagamento de sua preferência.""",
                        ),
                        Question(
                          title:
                              "Posso mudar o valor extra do Agente após o checkout?",
                          answer: """Em breve.""",
                        ),
                        Question(
                          title:
                              "Posso especificar um horário de entrega para o meu pedido?",
                          answer: """Em breve.""",
                        ),
                        Question(
                          title:
                              "Vocês irão usar meu telefone para entrar em contato comigo?",
                          answer: """Em breve.""",
                        ),
                        Question(
                          title:
                              "Eu posso solicitar uma nota fiscal para os meus pedidos?",
                          answer:
                              """Para que possamos realizar a reconciliação fiscal, precisamos da nota física. Por isso, sempre que seu pedido é entregue, você recebe uma notificação para informar que o seu recibo está disponível. Dentro de alguns dias você encontrará nele uma foto da Nota Fiscal da compra. Além disso, você sempre poderá solicitá-la escrevendo para suporte@mercadoexpresso.com.br. 

A nota fiscal da compra é emitida diretamente pelo estabelecimento em que ela foi realizada. A MercadoExpresso somente emite NFs referentes às taxas que cobramos, como de entrega e de serviço, por exemplo. Para solicitá-la, basta entrar em contato com nosso suporte através do aplicativo ou do e-mail supramencionado.
""",
                        ),
                        Question(
                          title: "Quando a gorjeta do Agente será cobrado?",
                          answer: """Será cobrado 6 horas após a entrega.""",
                        ),
                        Question(
                          title:
                              "O Agente recebe o total da gorjeta que forneço?",
                          answer:
                              """A MercadoExpresso não leva nenhuma porcentagem disso. Quando o pagamento é feito por cartão, é feito apenas o desconto da taxa do Gateway de pagamentos, mas para pagamentos realizados por PIX, o valor é integralmente transferido ao Agente.""",
                        ),
                        Question(
                          title:
                              "O Agente está ciente da gorjeta que darei a ele?",
                          answer:
                              """O Agente poderá ver o valor extra que você deu a ele(a) 6 horas após a entrega ser concluída.""",
                        ),
                        Question(
                          title:
                              "Mas eu preciso da nota fiscal física para fazer uma troca. O que eu faço?",
                          answer:
                              """Pode ficar tranquilo(a), nós faremos a troca para você. Basta entrar em contato conosco pelo suporte dentro do aplicativo, ou pelo email suporte@mercadoexpresso.com.br que nós vamos resolver o seu problema.""",
                        ),
                        Question(
                          title:
                              "Quando meu pedido chegará e quais são os horários de entrega?",
                          answer:
                              """No momento os pedidos são entregues aproximadamente 90 minutos após a efetivação do pagamento. No entanto, em breve também estaremos trabalhando com agendamentos de entregas, seja para o mesmo dia ou para qualquer outra data futura, sempre respeitando os horários de funcionamento das lojas. A disponibilidade de horários aparece quando você está concluindo o seu pedido, no checkout. Lá você vai saber se pode ser sob demanda ou para quando vai poder agendar. """,
                        ),
                        Question(
                          title:
                              "Como posso modificar o telefone associado à minha conta da MercadoExpresso?",
                          answer:
                              """Solicite apoio no suporte dentro do aplicativo ou através do email suporte@mercadoexpresso.com.br""",
                        ),
                        Question(
                          title: "Como será feita a cobrança do seu pedido?",
                          answer:
                              """Tanto para pagamento com PIX como com cartão de crédito, a cobrança é realizada na tela de checkout, antes da confirmação da efetivação da compra. Após a confirmação do pagamento, a compra é confirmada automaticamente e inicia então o processo de entrega.""",
                        ),
                        Question(
                          title: "Quando receberei meu reembolso?",
                          answer:
                              """Se você tiver um reembolso pendente, depende do seu banco, não é culpa nossa, juro. Se você não receber o reembolso em sua conta após este período, entre em contato com o seu banco, pois alguns podem levar até dois fechamentos de fatura para processar esse tipo de solicitação.""",
                        ),
                        Question(
                          title:
                              "O que eu faço se precisar de um produto que não está disponível no catálogo da MercadoExpresso?",
                          answer:
                              """Escreva para a MercadoExpresso na seção suporte do aplicativo, detalhando dados importantes como marca, tamanho, quantidade, etc. Quanto melhor for a descrição do produto que você precisa, mais fácil será para que nós consigamos disponibilizá-lo na plataforma o quanto antes. Assim você ajuda a melhorar nosso serviço e a manter nosso catálogo atualizado.""",
                        ),
                        Question(
                          title:
                              "Posso receber meu pedido em um endereço diferente do habitual?",
                          answer:
                              """Sim! Você pode adicionar vários endereços de entrega à sua conta. O pedido será entregue no endereço que você escolher, apenas verifique se os dados (número, CEP, etc) estão corretos antes de confirmar a sua compra. Lembre-se que o endereço deve estar em nossa área de cobertura e que a MercadoExpresso não aceita entregas em locais públicos.""",
                        ),
                        Question(
                          title:
                              "O que acontece se eu não conseguir receber meu pedido? Alguém mais pode recebê-lo por mim?",
                          answer:
                              """Não tem problema. Ao confirmar seu pedido, diga-nos na seção “Instruções de entrega” ou diretamente no chat com o seu Agente o nome da pessoa que receberá seu pedido. Não esqueça de fornecer o código de segurança para que esta pessoa possa informar ao Agente e este possa validar o destinatário corretamente antes de entregar a encomenda, caso contrário esta não poderá ser entregue.""",
                        ),
                        Question(
                          title:
                              "Moro em condomínio e quero receber meu pedido em mãos, como proceder?",
                          answer:
                              """Se for um condomínio horizontal, basta autorizar a entrada do Agente na portaria e deixar claro nas “Instruções para Entrega” que o Agente deverá seguir até a sua residência para entregar seu pedido em mãos. 

No entanto, para condomínios verticais, o procedimento padrão é encontrar o cliente na portaria e realizar a entrega lá mesmo. A exceção é quando o cliente contratou um serviço adicional para “Entrega em mãos”. Portanto, se for o seu caso e fizer questão de receber seu pedido em mãos, não se esqueça de incluir o serviço adicional “Entrega em mãos” no momento do checkout para que o Agente que fará a entrega saiba que terá que atender a esta exceção, caso queira aceitar esta missão. """,
                        ),
                        Question(
                          title:
                              "O que eu faço se algo der errado com meu pedido?",
                          answer:
                              """Lamentamos muito por você ter tido uma experiência ruim. Nesse caso, acesse a seção suporte no aplicativo ou escreva para suporte@mercadoexpresso.com.br e encontraremos a melhor solução para o seu problema. """,
                        ),
                        Question(
                          title:
                              "Quando meu pedido chegará e quais são os horários de entrega?",
                          answer:
                              """No momento estamos trabalhando apenas com a entrega na hora (nos próximos 90 minutos após a confirmação do pagamento). Futuramente disponibilizaremos outras opções como entrega agendada.""",
                        ),
                        Question(
                          title: "Como atualizo meu método de pagamento?",
                          answer:
                              "Acesse sua ‘Conta’, depois ‘Formas de pagamento’ e, em seguida, ‘Adicionar, modificar e/ou excluir suas formas de pagamento’. Você pode ter mais de uma forma de pagamento cadastrada, ou mesmo nenhuma e realizar o pagamento através de PIX no momento do checkout.",
                        ),
                        Question(
                          title: "Eu devo dar um valor extra para o Agente?",
                          answer:
                              """As gorjetas são voluntárias, mas sempre muito apreciadas. Você pode dar um valor extra ao seu Agente por meio do aplicativo. """,
                        ),
                        Question(
                          title:
                              "O Agente vai levar tudo direto para minha porta, podendo entrar no meu condomínio?",
                          answer:
                              """O Agente é parceiro da MercadoExpresso, por isso, não podemos garantir que ele vá subir em seu prédio. Normalmente os pedidos são entregues para você ou por alguém por você autorizado na portaria. No entanto, você pode contratar esse serviço como um adicional ao realizar o checkout da sua compra e neste caso, o Agente que aceitar a missão de entregá-lo, se compromete a fazer cumprir o que foi descrito no campo “Instruções de entrega”. Não se esqueça de que precisará de sua autorização para subir. """,
                        ),
                        Question(
                          title: "Tenho como saber o status do meu pedido?",
                          answer:
                              """Quando você confirmar sua compra, enviaremos uma notificação com o título ‘Confirmação do pedido’, na qual você poderá veririar todas as informações referentes à sua compra.

Você pode monitorar o status do seu pedido pelo aplicativo, saber se o Agente já está buscando o produto, ou se já partiu para o endereço de entrega. """,
                        ),
                        Question(
                          title:
                              "Qual o valor da taxa de serviço na MercadoExpresso?",
                          answer:
                              """A taxa de serviço é um percentual de 15% cobrado sobre o valor final do pedido.""",
                        ),
                        Question(
                          title:
                              "Esta taxa de serviço consta nos Termos e Condições?",
                          answer:
                              """Neste link você pode conferir os Termos e Condições que foram aceitos no momento em que você criou sua conta: XXXXXXXXXXX
Você pode conferir o ponto “XXX. Pagamento”, para mais detalhes.""",
                        ),
                        Question(
                          title: "Como funciona o programa de indicações?",
                          answer:
                              """O programa de indicações é uma ferramenta da MercadoExpresso onde você pode indicar amigos para usufruírem de nossos serviços. Vá na aba ‘Conta’ e depois ‘Compartilhar’, copie o código e divulgue para todos os seus amigos. Cada pessoa que você convida para a MercadoExpresso ganha uma entrega grátis válida por 14 dias corridos (pedido mínimo de R\$ 50 reais). E para cada uma delas que faz o cadastro pelo seu código, compra e recebe o pedido, você ganha R\$ 15,00 em créditos MercadoExpresso válidos por 14 dias corridos. """,
                        ),
                        Question(
                          title:
                              "Como funciona a entrega de bebidas alcoólicas?",
                          answer:
                              """Para que possamos entregar um pedido que inclua bebidas alcoólicas, uma pessoa maior de idade deve estar presente quando o Agente chegar com a encomenda. Será necessário verificar o RG ou habilitação do cliente. Não se esqueça de beber com moderação!""",
                        ),
                        Question(
                          title: "Quais são meus direitos como Cliente? ",
                          answer:
                              """É importante que você leia nossos Termos e Condições. Lá você encontrará informações importantes sobre seus direitos, responsabilidades, detalhes sobre repasses, dentre outras coisas importantes. """,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: wXD(100, context)),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
            right: visibleSupport ? wXD(16, context) : wXD(-60, context),
            bottom: wXD(100, context),
            child: GestureDetector(
              onTap: () {
                print('onTap');
                Modular.to.pushNamed('/support/support-chat');
              },
              child: Container(
                  height: wXD(56, context),
                  width: wXD(56, context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getColors(context).surface,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        offset: Offset(0, 3),
                        color: getColors(context).shadow,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.support_agent,
                    color: getColors(context).onSurface,
                    size: wXD(35, context),
                  )
                  // Image.asset("./assets/images/AlienSupport.png")
                  ),
            ),
          ),
          DefaultAppBar("Suporte"),
        ],
      ),
    );
  }
}

class Question extends StatefulWidget {
  final String title;
  final String answer;
  const Question({Key? key, required this.title, required this.answer})
      : super(key: key);

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => visible = !visible),
          child: Container(
            alignment: Alignment.bottomCenter,
            // height: wXD(20, context),
            child: Column(
              children: [
                SizedBox(height: wXD(7, context)),
                Row(
                  children: [
                    Container(
                      width: wXD(305, context),
                      child: Text(
                        widget.title,
                        style: textFamily(
                          context,
                          fontSize: 12,
                          color: getColors(context).onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacer(),
                    Transform.rotate(
                      angle: visible ? math.pi / -2 : math.pi / 2,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: wXD(15, context),
                        color: getColors(context).primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: wXD(7, context)),
              ],
            ),
          ),
        ),
        Visibility(
          visible: visible,
          child: Container(
            child: Text(
              widget.answer,
              style: textFamily(
                context,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: getColors(context).onBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
